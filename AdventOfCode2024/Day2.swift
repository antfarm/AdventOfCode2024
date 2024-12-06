//
//  Day2.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 02.12.24.
//

import Foundation


struct Day2 {
    
    static func part1(_ input: String) -> String {
        
        let safeReports = reports(fromInput: input).filter { isSafe(report: $0) }
        
        return String(safeReports.count)
    }
    
    
    static func part2(_ input: String) -> String {
        
        // No need to check with isSafe() first, as every safe report will
        // still be safe with the first level removed.

        let safeReports = reports(fromInput: input).filter { report in
            Array(0..<report.count).contains(where: { i in
                isSafe(report: Array(report[..<i] + report[(i + 1)...]))
            })
        }
        
        return String(safeReports.count)
    }

        
    fileprivate static func isSafe(report: [Int]) -> Bool {

        let pairs = zip(report, report.dropFirst())
        
        return (pairs.allSatisfy(<=) || pairs.allSatisfy(>=))
            && pairs.allSatisfy { (1...3).contains(abs($0.0 - $0.1)) }
    }


    fileprivate static func reports(fromInput input: String) -> [[Int]] {
        
        let lines = input.split(separator: "\n")
        
        return lines.map { line in
            line.split(separator: " ").map { Int($0)! }
        }

    }
}
