//
//  Day8.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 08.12.24.
//

import Foundation


struct Day8 {
    
    static func part1(_ input: String) -> String {
        
        let uniqueAntinodes = uniqueAntinodes(fromInput: input) { (antenna1, antenna2) in

            let deltaX = antenna1.0 - antenna2.0,
                deltaY = antenna1.1 - antenna2.1

            let antinodes = [(antenna1.0 + deltaX, antenna1.1 + deltaY),
                             (antenna2.0 - deltaX, antenna2.1 - deltaY)]
            
            return antinodes
        }
        
        return String(uniqueAntinodes.count)
    }
    
    
    static func part2(_ input: String) -> String {
     
        let width = input.split(separator: "\n").first!.count
        
        let uniqueAntinodes = uniqueAntinodes(fromInput: input) { (antenna1, antenna2) in

            let (x1, y1) = (Double(antenna1.0), Double(antenna1.1)),
                (x2, y2) = (Double(antenna2.0), Double(antenna2.1))
            
            let a = (y2 - y1) / (x2 - x1), // slope
                b = y1 - a * x1 // intercept
                        
            let linearFunction: (Int) -> Double = { x in a * Double(x) + b }
            
            let antinodes = (0..<width).compactMap { x in
                
                let y = linearFunction(x)
                
                let yRounded = y.rounded(.toNearestOrEven)
                
                return abs(y - yRounded) < 0.00001 ? (x, Int(yRounded)) : nil
            }

            return antinodes
        }

        return String(uniqueAntinodes.count)
    }
    
    
    fileprivate static func uniqueAntinodes(fromInput input: String,
                                            antinodeClosure: (((Int, Int), (Int, Int))) -> [(Int, Int)]) -> [(Int, Int)] {
        
        let frequencies = Array(Set(input).subtracting(Set(".#\n"))).map { String("\($0)") }

        let world = input.split(separator: "\n").map { line in Array(line).map { "\($0)" } }
        let (width, height) = (world[0].count, world.count)
        
        let coordinates = Array(world.indices).reduce([]) { coords, row in
            coords + Array(world[row].indices).map { column in [(Int(column), Int(row))] }.reduce([], +)
        }

        let antinodes: [(Int, Int)] = frequencies.reduce([]) { allAntinodes, frequency in
            
            let antennas = coordinates.filter { world[$0.0][$0.1] == frequency }
            
            let antennaPairs = antennas.indices.reduce([]) { pairs, i in
                pairs + antennas[(i+1)...].map { element in (antennas[i], element) }
            }
            
            let antinodes = antennaPairs.reduce([]) { antinodes, pair in
                antinodes + antinodeClosure(pair)
            }
            
            let antinodesInside = antinodes.filter { (x, y) in
                (0..<width).contains(x) && (0..<height).contains(y) }
            
            return allAntinodes + antinodesInside
        }
        
        let uniqueAntinodes = Set(antinodes.map { "\($0.0)|\($0.1)" })
            .map { $0.split(separator: "|") }.map { (Int($0[0])!, Int($0[1])!) }
        
        return uniqueAntinodes
    }
}


/**
 
 9 . . . . . . . . . . . . o . . . . . . .
 8 . . . . . . . . . . . . . . . . . . . .
 7 . . . . . . . . . . . o . . . . . . . .
 6 . . . . . . . . . . . . . . . . . . . .
 5 . . . . . . . . . . o . . . . . . . . .
 4 . . . . . . . . . . . . . . . . . . . .
 3 . . . . . . . . . o . . . . . . . . . .
 2 . . . . . . . . . . . . . . . . . . . .
 1 . . . . . . . . B . . . . . . . . . . .
 0 . . . . . . . . . . . . . . . . . . . .
 9 . . . . . . . o . . . . . . . . . . . .
 8 . . . . . . . . . . . . . . . . . . . .
 7 . . . . . . A . . . . . . . . . . . . .
 6 . . . . . . . . . . . . . . . . . . . .
 5 . . . . . o . . . . . . . . . . . . . .
 4 . . . . . . . . . . . . . . . . . . . .
 3 . . . . o . . . . . . . . . . . . . . .
 2 . . . . . . . . . . . . . . . . . . . .
 1 . . . o . . . . . . . . . . . . . . . .
 0 . . . . . . . . . . . . . . . . . . . .
   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9
 
 */
