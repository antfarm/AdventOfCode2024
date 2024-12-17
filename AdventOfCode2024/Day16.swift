//
//  Day16.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 16.12.24.
//

import Foundation


struct Day16 {
    
    static func part1(_ input: String) -> String {
        
        let grid = grid(fromInput: input)
        
        let columnCount = grid.count
        let rowCount = grid[0].count

        let coordinates = (0..<rowCount).reduce([]) { coords, y in
            coords + (0..<columnCount).map { x in [(x, y)] }.reduce([], +)
        }
        
        let start = coordinates.filter { x, y in grid[x][y] == "S" }.first!
        let end  = coordinates.filter { x, y in grid[x][y] == "E" }.first!
        let heading = (1, 0)

        let nodes = coordinates.filter { x, y in grid[x][y] == "." }

        //print(toString(start: start, end: end, nodes: nodes, columnCount: columnCount, rowCount: rowCount))
        
        let cost = shortestPathCost(from: start, to: end, heading: heading, nodes: nodes)
    
        return String(cost)
    }
    
    
    fileprivate static func shortestPathCost(from start: (Int, Int), to end: (Int, Int), heading: (Int, Int),
                                             nodes: [(Int, Int)], visited: [((Int, Int), (Int))] = []) -> Int {
        
        let nodes = adjacentNodes(node: start, heading: heading, nodes: nodes)
        
        print(nodes) // TODO: Dijkstra's algorithm [https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm]

        return 0
        
    }
    
    
    fileprivate static func adjacentNodes(node: (Int, Int), heading: (Int, Int), nodes: [(Int, Int)]) -> [((Int, Int), (Int, Int), Int)] {
        
        let (x, y) = node
        
        let directions = [(-1, 0), (0, -1), (1, 0), (0, 1)] // [< v > ^]
        
        let adjacentNodes: [((Int, Int), (Int, Int), Int)?] = directions.map { direction in
            
            let neighbor = (x + direction.0, y + direction.1)
            
            guard nodes.contains(where: { $0.0 == neighbor.0 && $0.1 == neighbor.1 }) else {
                return nil
            }
            
            let diff = abs(directions.firstIndex { $0.0 == direction.0 && $0.1 == direction.1}!
                         - directions.firstIndex { $0.0 == heading.0 && $0.1 == heading.1}!)
            
            let turnsCount = min(diff, 4 - diff)
            let cost = turnsCount * 1000 + 1
            
            return (neighbor, direction, cost)
        }
        
        return adjacentNodes.compactMap { $0 }
    }

    
    fileprivate static func grid(fromInput input: String) -> [[Character]] {
        
        let lines = input.split(separator: "\n")
        
        let rows = lines.map { line in Array(line).map { $0 } }
        let columns: [[Character]] = rows[0].indices.map { i in rows.map { line in line[i] } }
        
        return columns
    }
    
    
    fileprivate static func toString(start: (Int, Int), end: (Int, Int), nodes: [(Int, Int)], columnCount: Int, rowCount: Int) -> String {
           
        let coordinates = (0..<rowCount).reduce([]) { coords, y in
            coords + (0..<columnCount).map { x in [(x, y)] }.reduce([], +)
        }
        
        let cells = coordinates.reduce("") { cells, coords in
            let (x, y) = coords
            
            let cell =
                x == start.0 && y == start.1 ? "S"
                : x == end.0 && y == end.1 ? "E"
                : nodes.contains { x == $0.0 && y == $0.1 } ? "."
                : "#"
            
            return cells + cell + (x % columnCount == columnCount - 1 ? "\n" : "")
        }
        
        return cells
    }
}
