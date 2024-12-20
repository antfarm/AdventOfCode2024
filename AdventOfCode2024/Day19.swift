//
//  Day19.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 19.12.24.
//

import Foundation


struct Day19 {
    
    static func part1(_ input: String) -> String {
        
        let (patterns, designs) = patternsAndDesigns(fromInput: input)

        let regex = try! Regex("^(\(patterns.joined(separator: "|")))+$")
        let count = designs.count { $0.contains(regex) }
        
        return String(count)
    }
    

    static func part2(_ input: String) -> String {
        
        let (patterns, designs) = patternsAndDesigns(fromInput: input)
        
        let count = designs
            .map { countCombinations(design: $0, patterns: patterns) }
            .reduce(0, +)
        
        return String(count)
    }
    
    
    fileprivate static func countCombinations(design: String, patterns: [String]) -> Int {

        var counts: [String:Int] = [:] // TODO: Cache counts without mutable state
        
        let regex = try! Regex("^(\(patterns.joined(separator: "|")))+$")
        guard design.contains(regex) else { return 0 }

        func countCombinations(design: String) -> Int {
            if design.isEmpty { return 1 }
            
            let designs = patterns
                .filter { design.starts(with: $0) }
                .map { String(design.dropFirst($0.count)) }
                        
            return designs.map { design in
                if let count = counts[design] { return count }
                counts[design] = countCombinations(design: design)
                return counts[design]!
            }
            .reduce(0, +)
        }
        
        return countCombinations(design: design)
    }

    
    static func patternsAndDesigns(fromInput input: String) -> ([String], [String]) {
        
        let lines = input.split(separator: "\n")
        
        let patterns = lines[0].split(separator: ", ").map { String($0) }
        let designs = Array(lines[1...].map { String($0) })
        
        return (patterns, designs)
    }
}
