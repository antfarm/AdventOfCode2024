//
//  Day1.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 01.12.24.
//

import Foundation


struct Day1 {
    
    static func part1(_ input: String) -> String {
        
        let (left, right) = lists(fromInput: input)
        
        let differences = zip(left.sorted(), right.sorted()).map { abs($0.0 - $0.1) }
        let sum = differences.reduce(0, +)
        
        return String(sum)
    }
    
    
    static func part2(_ input: String) -> String {
        
        let (left, right) = lists(fromInput: input)
        
        let frequencies = Dictionary(right.map { ($0, 1) }, uniquingKeysWith: +)
        
        let values = left.map { $0 * (frequencies[$0] ?? 0) }
        let sum = values.reduce(0, +)
        
        return String(sum)
    }
    
    
    static fileprivate func lists(fromInput input: String) -> ([Int], [Int]) {
        
        let lines = input.split(separator: "\n")
        let pairs = lines.map { $0.split(separator: "   ").map { Int($0)! } }
        
        let left = pairs.map { $0.first! }
        let right = pairs.map { $0.last! }
        
        return (left, right)
    }
}
