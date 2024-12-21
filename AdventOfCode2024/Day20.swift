//
//  Day20.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 20.12.24.
//

import Foundation


struct Day20 {
    
    static func part1(_ input: String) -> String {
        
        let grid = grid(fromInput: input)
        
        let cheatOffsets = cheatOffsets(n: 2)        
        let count = countCheats(offsets: cheatOffsets, savingThreshold: 100, grid: grid)
        
        return String(count)
    }

    
    static func part2(_ input: String) -> String {
        
        let grid = grid(fromInput: input)
        
        let cheatOffsets = cheatOffsets(n: 20)
        let count = countCheats(offsets: cheatOffsets, savingThreshold: 100, grid: grid)
        
        return String(count)
    }


    fileprivate static func countCheats(offsets: [(Int, Int)], savingThreshold: Int, grid: [[Character]]) -> Int {
        
        let coordinates = coordinates(inGrid: grid)
        
        let start = coordinates.filter { x, y in grid[x][y] == "S" }.first!
        let end  = coordinates.filter { x, y in grid[x][y] == "E" }.first!
        let nodes = coordinates.filter { x, y in grid[x][y] == "." }

        //print(toString(start: start, end: end, nodes: nodes, columnCount: columnCount, rowCount: rowCount))

        let path = path(start: start, end: end, nodes: nodes)

        let savings = path.flatMap { x, y in
            
            let cheats = offsets
                .map { dx, dy in (x + dx, y + dy) }
                .filter { cheat in path.contains { $0 == cheat } }
            
            return cheats.map { cheat in
                distance(onPath: path, from: (x, y), to: cheat) - manhattanDistance(from: (x, y), to: cheat)
            }
        }
        
        //let histogram = Dictionary(savings.map { ($0, 1) }, uniquingKeysWith: +).sorted(by: <)
        //for (key, value) in histogram { print("\(key): \(value)") }
        
        let count = savings.count { $0 >= savingThreshold }

        return count
    }

    
    fileprivate static func cheatOffsets(n: Int) -> [(Int, Int)] {
    /**
     [
                                   (0, -3),
                         (-1, -2), (0, -2), (1, -2),
               (-2, -1), (-1, -1),          (1, -1), (2, -1),
     (-3,  0), (-2,  0),                             (2,  0), (3,  0),
               (-2,  1), (-1,  1),          (1,  1), (2,  1),
                         (-1,  2), (0,  2), (1,  2),
                                   (0,  3)
     ]
     */
        (-n...n).flatMap { y in
            (-(n - abs(y))...(n - abs(y))).map { x in (x, y) }
        }
        .filter { cheat in
            ![(0, -1), (-1, 0), (0, 0), (1, 0), (0, 1)].contains { $0 == cheat }
        }
    }

    
    fileprivate static func distance(onPath path: [(Int, Int)], from position1: (Int, Int), to position2: (Int, Int)) -> Int {
    
        let index1 = path.firstIndex { $0 == position1 }!
        let index2 = path.firstIndex { $0 == position2 }!
        
        return index2 - index1
    }

    
    fileprivate static func manhattanDistance(from position1: (Int, Int), to position2: (Int, Int)) -> Int {
    
        let dx = abs(position1.0 - position2.0)
        let dy = abs(position1.1 - position2.1)
        
        return dx + dy
    }

    
    fileprivate static func path(start: (Int, Int), end: (Int, Int), nodes: [(Int, Int)]) -> [(Int, Int)] {
        
        let offsets = [(-1, 0), (0, -1), (1, 0), (0, 1)]
        
        func traversePath(visited: [(Int, Int)] = []) -> [(Int, Int)] {
            
            let position = visited.last ?? start
            
            if position == end { return visited }
           
            let (x, y) = position
            
            let next = offsets.map { (dx, dy) in (x + dx, y + dy) }
                .filter { pos in (nodes + [end]).contains { pos == $0 } }
                .filter { pos in !visited.contains  { pos == $0 } }
            
            return traversePath(visited: visited + next)
        }
        
        return [start] + traversePath()
    }
    
    
    fileprivate static func coordinates(inGrid grid: [[Character]]) -> [(Int, Int)] {
        
        let columnCount = grid.count
        let rowCount = grid[0].count
        
        return (0..<rowCount).reduce([]) { coords, y in
            coords + (0..<columnCount).map { x in [(x, y)] }.reduce([], +)
        }
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
