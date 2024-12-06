//
//  Day5.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 05.12.24.
//

import Foundation


struct Day5 {
    
    static func part1(_ input: String) -> String {
        
        let correctUpdates = filterUpdates(input: input, isCorrect: true)
        
        let result = correctUpdates.reduce(0) { sum, update in
            sum + update[update.count/2]
        }
        
        return String(result)
    }
    
    
    static func part2(_ input: String) -> String {
        
        let incorrectUpdates = filterUpdates(input: input, isCorrect: false)
        
        func orderCorrectly(update: [Int]) -> [Int] {
            update // TODO
        }
        
        let correctUpdates = incorrectUpdates.map { orderCorrectly(update: $0) }
        
        let result = correctUpdates.reduce(0) { sum, update in
            sum + update[update.count/2]
        }
        
        return String(result) // TODO
    }
    
    
    fileprivate static func filterUpdates(input: String, isCorrect: Bool) -> [[Int]] {
        
        let lines = input.split(whereSeparator: \.isNewline)
        
        let reversedRulePairs = lines.filter { $0.contains("|") }
            .map { line in
                let components = line.split(separator: "|").map { Int($0)! }
                return (components.last!, [components.first!]) // reversed!
            }
        
        let forbiddenFollowingPagesByPage = Dictionary(reversedRulePairs, uniquingKeysWith: +)
        
        let updates = lines.filter { $0.contains(",") }
            .map { $0.split(separator: ",").map { Int($0)! } }
        
        func isCorrectlyOrdered(update: [Int]) -> Bool {
            
            if update.count == 1 { return true }
            
            let page = update[0]
            let followingPages = Array(update[1...])
            let forbiddenFollowingPages = forbiddenFollowingPagesByPage[page] ?? []
            
            let isCorrect = Set(followingPages).intersection(Set(forbiddenFollowingPages)).isEmpty
            
            if !isCorrect { return false }
            
            return isCorrectlyOrdered(update: followingPages)
        }
        
        return updates.filter { isCorrect ? isCorrectlyOrdered(update: $0) : !isCorrectlyOrdered(update: $0) }
    }
}
