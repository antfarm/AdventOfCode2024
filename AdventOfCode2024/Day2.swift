//
//  Day2.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 02.12.24.
//

import Foundation


struct Day2 {
    
    static func part1(_ input: String) -> String {
        
        let reports = createReports(fromInput: input)
        
        let safeReports = reports.filter { isReportSafe(report: $0) }
        
        return String(safeReports.count)
    }
    
    
    static func part2(_ input: String) -> String {
        
        let reports = createReports(fromInput: input)
              
        let safeReports = reports.filter { report in
            
            if isReportSafe(report: report) {
                return true
            }
            
            let dampenedReportIndex = Array(0..<report.count).first(where: { i in
                isReportSafe(report: Array(report[..<i] + report[(i + 1)...]))
            })

            return dampenedReportIndex != nil
        }
        
        return String(safeReports.count)
    }

        
    fileprivate static func isReportSafe(report: [Int]) -> Bool {

        let pairs = zip(report, report.dropFirst())
        
        return (pairs.allSatisfy(<=) || pairs.allSatisfy(>=))
            && pairs.allSatisfy { (1...3).contains(abs($0.0 - $0.1)) }
    }


    fileprivate static func createReports(fromInput input: String) -> [[Int]] {
        
        let lines = input.components(separatedBy: "\n")
        
        let reports = lines.map { line in
            line.components(separatedBy: " ").map { Int($0)! }
        }
        
        return reports
    }
}
