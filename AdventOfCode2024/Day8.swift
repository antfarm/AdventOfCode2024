//
//  Day8.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 08.12.24.
//

import Foundation


struct Day8 {
    
    static func part1(_ input: String) -> String {
        
        let frequencies = Array(Set(input).subtracting(Set(".#\n"))).map { String($0) }

        let world = input.split(separator: "\n").map { line in Array(line).map { String($0) } }
        let (width, height) = (world.count, world[0].count)
        
        let coordinates = Array(world.indices).reduce([]) { coords, row in
            coords + Array(world[row].indices).map { column in [(Int(column), Int(row))] }.reduce([], +)
        }

        let antinodes: [(Int, Int)] = frequencies.reduce([]) { allAntinodes, frequency in
            
            let antennas = coordinates.filter { world[$0.0][$0.1] == frequency }
            
            let antennaPairs = antennas.indices.reduce([]) { pairs, i in
                pairs + antennas[(i+1)...].map { element in (antennas[i], element) }
            }
            
            let antinodes: [(Int, Int)] = antennaPairs.reduce([]) { antinodes, pair in
                let (antenna1, antenna2) = pair
                
                let deltaX = antenna1.0 - antenna2.0,
                    deltaY = antenna1.1 - antenna2.1
                
                let antinode1 = (antenna1.0 + deltaX, antenna1.1 + deltaY),
                    antinode2 = (antenna2.0 - deltaX, antenna2.1 - deltaY)
                
                return antinodes + [antinode1, antinode2].filter { (0..<width).contains($0.0)
                                                                && (0..<height).contains($0.1) }
            }
            
            return allAntinodes + antinodes
        }

        let uniqueAntinodes = Set(antinodes.map { "\($0.0)|\($0.1)" })
            .map { $0.split(separator: "|") }.map { ($0[0], $0[1]) }
        
        return String(uniqueAntinodes.count)
    }
}
