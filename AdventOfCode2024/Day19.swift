//
//  Day19.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 19.12.24.
//

import Foundation


struct Day19 {
    
    static func part1(_ input: String) -> String {
        
        let (elements, combinations) = combinations(fromInput: input)

        let regex = try! Regex("^(\(elements.joined(separator: "|")))+$")
        let count = combinations.count { $0.firstMatch(of: regex) != nil }
        
        return String(count)
    }
    
    
    static func combinations(fromInput input: String) -> ([String], [String]) {
        
        let lines = input.split(separator: "\n")
        
        let elements = lines[0].split(separator: ", ").map { String($0) }
        let combinations = Array(lines[1...].map { String($0) })
        
        return (elements, combinations)
    }
}
