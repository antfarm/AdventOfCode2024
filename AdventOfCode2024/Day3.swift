//
//  Day3.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 03.12.24.
//

import Foundation


struct Day3 {
    
    static func part1(_ input: String) -> String {
        
        let regex = /mul\(([1-9][0-9]{0,2}),([1-9][0-9]{0,2})\)/
        
        let result = input
            .matches(of: regex)
            .map { Int($0.1)! * Int($0.2)! }
            .reduce(0, +)
        
        return String(result)
    }
        
    
    static func part2(_ input: String) -> String {
        
        let regex = /do\(\)(.*?)don't\(\)/.dotMatchesNewlines() // ? for lazy matching

        let enabledInput = "do()\(input)don't()"
            .matches(of: regex)
            .map { $0.1 }
            .joined(separator: " ")
        
        return part1(enabledInput)
    }
}
