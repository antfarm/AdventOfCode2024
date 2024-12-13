//
//  Day13.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 13.12.24.
//

import Foundation


struct Day13 {
    
    static func part1(_ input: String) -> String {
        
        let machines = clawMachines(fromInput: input)
        
        let tokenCount = machines.reduce(0) { tokenCount, machine in            
            let (buttonA, buttonB, prize) = machine
            
            guard let (a, b) = solveLinearCombination(a: buttonA, b: buttonB, c: prize) else {
                return tokenCount
            }
            
            return tokenCount + a * 3 + b
        }
        
        return String(tokenCount)
    }
    
    
    static func part2(_ input: String) -> String {
        
        let machines = clawMachines(fromInput: input)
        
        let tokenCount = machines.reduce(0) { tokenCount, machine in
            let (buttonA, buttonB, prize) = machine
            
            let error = 10000000000000
            let correctedPrize = (prize.0 + error, prize.1 + error)
            
            guard let (a, b) = solveLinearCombination(a: buttonA, b: buttonB, c: correctedPrize) else {
                return tokenCount
            }
            
            return tokenCount + a * 3 + b
        }
        
        return String(tokenCount)
    }
    
    
    // ChatGPT: "How do I find m and n so that m * (a0, a1) + n * (b0, b1) = (c0, c1)?"
    
    fileprivate static func solveLinearCombination(a: (Int, Int), b: (Int, Int), c: (Int, Int)) -> (Int, Int)? {
        
        let det = a.0 * b.1 - a.1 * b.0
        
        guard det != 0 else { return nil }
        
        let m = b.1 * c.0 - b.0 * c.1
        let n = -a.1 * c.0 + a.0 * c.1
        
        guard m % det == 0, n % det == 0 else { return nil }
        
        return (m / det, n / det)
    }
    
    
    fileprivate static func clawMachines(fromInput input: String) -> [((Int, Int), (Int, Int), (Int, Int))] {
     
        let regex = /Button A: X\+([0-9]+), Y\+([0-9]+)\nButton B: X\+([0-9]+), Y\+([0-9]+)\nPrize: X=([0-9]+), Y=([0-9]+)/

        let machines = input
            .matches(of: regex)
            .map { ((Int($0.1)!, Int($0.2)!), (Int($0.3)!, Int($0.4)!), (Int($0.5)!, Int($0.6)!))  }
        
        return machines
    }
}

