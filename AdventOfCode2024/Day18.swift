//
//  Day18.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 18.12.24.
//

import Foundation


struct Day18 {
    
    static let size = 71
    static let obstacleCount = 1024

    static func part1(_ input: String) -> String {
        
        let obstacles = Array(obstacles(fromInput: input)[0..<obstacleCount])
        
        let start = (0, 0)
        let end = (size - 1, size - 1)
        
        let cost = costOfShortestPath(start: start, end: end, obstacles: obstacles, size: size)!
        
        return String(cost)
    }
    
    
    static func part2(_ input: String) -> String {
        
        let obstacles = obstacles(fromInput: input)
        
        let start = (0, 0)
        let end = (size - 1, size - 1)
        
        func binarySearch(_ n1: Int, _ n2: Int) -> Int {
            
            if n2 - n1 == 1 { return n1 }
                
            let n = n1 + (n2 - n1) / 2
            let obstacles = Array(obstacles[0..<n])
            
            if let _ = costOfShortestPath(start: start, end: end, obstacles: obstacles, size: size) {
                return binarySearch(n, n2)
            }

            return binarySearch(n1, n)
        }
        
        let index = binarySearch(obstacleCount, obstacles.count)
        let obstacle = obstacles[index]
        
        return String("\(obstacle.0),\(obstacle.1)")
    }
    
    
    
    fileprivate static func costOfShortestPath(start: (Int, Int), end: (Int, Int), obstacles: [(Int, Int)], size: Int, cost: Int = 0) -> Int? {
        
        let offsets = [(-1, 0), (0, -1), (1, 0), (0, 1)]
        
        func costOfShortestPath(frontier: [(Int, Int)], visited: [(Int, Int)] = [], cost: Int = 0) -> Int? {
                        
            if frontier.isEmpty { return nil }
            
            if frontier.contains(where: { $0 == end }) { return cost }
            
            let neighbors = frontier.flatMap { x, y in                
                offsets.map { dx, dy in
                    (x + dx, y + dy)
                }
                .filter { x, y in
                    (0..<size).contains(x) && (0..<size).contains(y)
                }
                .filter { x, y in
                    !obstacles.contains(where: { $0 == (x, y) })
                }
            }

            let uniqueNeighbors = Set(neighbors.map { "\($0.0)|\($0.1)" })
                .map { $0.split(separator: "|") }.map { (Int($0[0])!, Int($0[1])!)
            }

            let visited = frontier + visited

            let frontier = uniqueNeighbors.filter { x, y in
                !visited.contains(where: { $0 == (x, y) })
            }
            
            return costOfShortestPath(frontier: frontier, visited: visited, cost: cost + 1)
        }
        
        return costOfShortestPath(frontier: [start])
    }

    
    fileprivate static func obstacles(fromInput input: String) -> [(Int, Int)] {
        
        let lines = input.split(separator: "\n")
        
        return lines.map { line in
            let coordinate = line.split(separator: ",")
            return (Int(coordinate[0])!, Int(coordinate[1])!)
        }
    }
}
