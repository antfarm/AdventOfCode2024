//
//  Day10.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 10.12.24.
//

import Foundation


struct Day10 {
    
    static func part1(_ input: String) -> String {
        
        let grid = grid(fromInput: input)
        let endpoints = endpointsByTrailhead(inGrid: grid)

        let score = endpoints.map { Array(Set($0)) }.reduce([], +).count
        
        return String(score)
    }
    
    
    static func part2(_ input: String) -> String {
        
        let grid = grid(fromInput: input)
        let endpoints = endpointsByTrailhead(inGrid: grid)
        
        let rating = endpoints.reduce([], +).count
        
        return String(rating)
    }

    
    fileprivate static func endpointsByTrailhead(inGrid grid: [[Int]]) -> [[Int]] {
        
        let columns = grid.indices
        let rows = grid[0].indices
        
        let coordinates = rows.reduce([]) { coords, y in
            coords + columns.map { x in [(x, y)] }.reduce([], +)
        }

        let trailheads = coordinates.filter { (x, y) in grid[x][y] == 0 }

        let offsets =  [(-1, 0), (0, -1), (1, 0), (0, 1)]
        
        func endpoints(reachableFrom start: (Int, Int)) -> [Int] {
            let (x, y) = start
            let height = grid[x][y]

            if height == 9 { return [x + y * rows.count] }

            let next = offsets
                .map { (dx, dy) in (x + dx, y + dy) }
                .filter { (x, y) in
                    columns.contains(x)
                    && rows.contains(y)
                    && grid[x][y] == height + 1
                }

            if next.count == 0 { return [] }
            
            return next.map { endpoints(reachableFrom: $0) }.reduce([], +)
        }
        
        return trailheads.map { endpoints(reachableFrom: $0) }
    }
    
    
    fileprivate static func grid(fromInput input: String) -> [[Int]] {
        
        let lines = input.split(separator: "\n")
        
        let rows = lines.map { line in Array(line).map { Int("\($0)")! } }
        let columns: [[Int]] = rows[0].indices.map { i in rows.map { line in line[i] } }
        
        return columns
    }
}
