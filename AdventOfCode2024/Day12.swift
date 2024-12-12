//
//  Day12.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 12.12.24.
//

import Foundation


struct Day12 {
    
    static func part1(_ input: String) -> String {
        
        let grid = grid(fromInput: input)
        let plants = Array(Set(input).subtracting(Set("\n")))
        let regions = plants.flatMap { allRegions(plant: $0, grid: grid) }
        
        let cost = regions.map { return $0.count * perimeter(region: $0) }.reduce(0, +)
                
        return String(cost)
    }
    
    
    fileprivate static func perimeter(region: [(Int, Int)]) -> Int {
        
        return region.reduce(0) { perimeter, plot in

            let neighbors = neighbors(plot: plot, offsets: [(-1, 0), (0, -1), (1, 0), (0, 1)])

            return perimeter + neighbors.count { (neighborX, neighborY) in
                !region.contains { (x, y) in (x, y) == (neighborX, neighborY)  }
            }
        }
    }
    
    
    fileprivate static func allRegions(plant: Character, grid: [[Character]]) -> [[(Int, Int)]]  {
        
        let plantCoordinates = coordinates(inGrid: grid).filter { (x, y) in grid[x][y] == plant }
        
        let regions: [[(Int, Int)]] = plantCoordinates.reduce([]) { regions, plot in

            let neighbors = neighbors(plot: plot, offsets: [(-1, 0), (0, -1)])
            
            let indices = regions.indices.filter { i in
                neighbors.contains { (neighborX, neighborY) in
                    regions[i].contains { (x, y) in (x, y) == (neighborX, neighborY)  }
                }
            }
            
            if indices.count == 1 {
                let index = indices[0]
                let region = [regions[index] + [plot]]
                
                return region + regions[0..<index] + regions[(index+1)...]
            }
            
            if indices.count == 2 {
                let (index1, index2) = (indices[0], indices[1])
                let region = [regions[index1] + regions[index2] + [plot]]
                
                return region + regions[0..<index1] + regions[(index1+1)..<(index2)] + regions[(index2+1)...]
            }
            
            return regions + [[plot]]
        }
        
        return regions
    }
    
    
    fileprivate static func neighbors(plot: (Int, Int), offsets: [(Int, Int)]) -> [(Int, Int)] {
        
        let (plotX, plotY) = plot
        let offsets = [(-1, 0), (0, -1), (1, 0), (0, 1)]
        
        return offsets.map { (dx, dy) in (plotX + dx, plotY + dy) }
    }
    
    
    fileprivate static func coordinates(inGrid grid: [[Character]]) -> [(Int, Int)] {
        
        let columns = grid.indices
        let rows = grid[0].indices
        
        return rows.reduce([]) { coords, y in
            coords + columns.map { x in [(x, y)] }.reduce([], +)
        }
    }

    
    fileprivate static func grid(fromInput input: String) -> [[Character]] {
        
        let lines = input.split(separator: "\n")
        
        let rows = lines.map { line in Array(line).map { $0 } }
        let columns: [[Character]] = rows[0].indices.map { i in rows.map { line in line[i] } }
        
        return columns
    }
}
