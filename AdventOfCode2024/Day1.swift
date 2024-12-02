//
//  Day1.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 01.12.24.
//

import Foundation


struct Day1 {
    
    static func part1(_ input: String) -> String {
        
        let (left, right) = createSortedLists(fromInput: input)
        
        let differences = left.enumerated().map { abs($1 - right[$0]) }
        let sum = differences.reduce(0, +)
        
        return String(sum)
    }
    
    
    static func part2(_ input: String) -> String {
        
        let (left, right) = createSortedLists(fromInput: input)
        
        let occurences = Dictionary(right.map { ($0, 1) }, uniquingKeysWith: +)
        
        let values = left.map { $0 * (occurences[$0] ?? 0) }
        let sum = values.reduce(0, +)
        
        return String(sum)
    }
    
    
    static private func createSortedLists(fromInput: String) -> ([Int], [Int]) {
        
        let lines = fromInput.components(separatedBy: "\n")
        let pairs = lines.map { $0.components(separatedBy: "   ") }
        
        let left = pairs.map { Int($0.first!)! }.sorted()
        let right = pairs.map { Int($0.last!)! }.sorted()
        
        return (left, right)
    }
}
