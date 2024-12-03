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

        let products = input
            .matches(of: regex)
            .map { Int($0.1)! * Int($0.2)! }
                
        let result = products.reduce(0, +)
        
        return String(result) // 170778545
    }
        
    
    static func part2(_ input: String) -> String {
        
        let regex = /do\(\)(.*?)don't\(\)/.dotMatchesNewlines() // ? for lazy (vs. greedy) matching
        
        let enabledParts = "do()\(input)don't()"
            .matches(of:regex)
            .map { $0.1 }
        
        let result = part1(enabledParts.joined(separator: " "))
        
        return result // 82868252
    }
}
