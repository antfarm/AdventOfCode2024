//
//  Day11.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 11.12.24.
//

import Foundation


struct Day11 {
    
    static func part1(_ input: String) -> String {
        
        let stones = input.split(separator: " ").map { Int($0)! }
        
        func replaceStones(stones: [Int], repeatCount: Int) -> [Int] {
            
            if repeatCount == 0 { return stones }
            
            let replacedStones = stones.flatMap { replaceStone(stone: $0) }
            
            return replaceStones(stones: replacedStones, repeatCount: repeatCount - 1)
        }

        let replacedStones = replaceStones(stones: stones, repeatCount: 25)
        
        return String(replacedStones.count)
    }
    
    
    
    // (Stolen) idea for scaling the solution to 75 iterations: The order of stones does not matter,
    // so it is sufficient to keep track of how often each number appears on the stones.
    
    static func part2(_ input: String) -> String {
        
        let stones = input.split(separator: " ").map { Int($0)! }
        
        let count = replaceStoneCounts(stones: stones, repeatCount: 75)

        return String(count)
    }


    fileprivate static func replaceStoneCounts(stones: [Int], repeatCount: Int) -> Int {
        
        let stoneCounts = Dictionary(uniqueKeysWithValues: stones.map { ($0, 1) })
        
        let stoneCountsReplaced = replaceStoneCounts(stoneCounts: stoneCounts, repeatCount: repeatCount)
        
        let count = stoneCountsReplaced.values.reduce(0, +)
        
        return count
    }
    

    fileprivate static func replaceStoneCounts(stoneCounts: [Int:Int], repeatCount: Int) -> [Int:Int] {
                    
        if repeatCount == 0 { return stoneCounts }
        
        let pairs = stoneCounts.flatMap { (number, count) in
            replaceStone(stone: number).map { ($0, count) }
        }
        
        let stoneCountsReplaced = Dictionary(pairs, uniquingKeysWith: +)
        
        return replaceStoneCounts(stoneCounts: stoneCountsReplaced, repeatCount: repeatCount - 1)
    }


    fileprivate static func replaceStone(stone: Int) -> [Int] {
                    
        if stone == 0 { return [1] }

        let digitsCount = Int(log10(Double(stone))) + 1
            
        if digitsCount.isMultiple(of: 2) {
            let pow10 = pow(10, Double(digitsCount/2))
            let stone1 = Int( Double(stone) / pow10 )
            let stone2 = stone - stone1 * Int(pow10)
            
            return [stone1, stone2]
        }
        
        return [stone * 2024]
    }
}
