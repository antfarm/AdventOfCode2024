
//  Day4.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 04.12.24.
//

import Foundation


struct Day4 {
    
    static func part1(_ input: String) -> String {
        
        let horizontalCount = countMatchesInRotatedInput(input: input) { _ in
            /XMAS/
        }
        
        let diagonalCount = countMatchesInRotatedInput(input: input) { n in
            try! Regex("(?=X.{\(n+1)}M.{\(n+1)}A.{\(n+1)}S)").dotMatchesNewlines() // ?= lookahead
        }
        
        return String(horizontalCount + diagonalCount) // 2560
    }
    
    
    static func part2(_ input: String) -> String {
        
        let count = countMatchesInRotatedInput(input: input) { n in
            try! Regex("(?=M.S.{\(n-1)}A.{\(n-1)}M.S)").dotMatchesNewlines() // ?= lookahead
        }
        
        return String(count) // 1910
    }
    
    
    fileprivate static func countMatchesInRotatedInput(input: String, regexClosure: (Int) -> Regex<Substring>) -> Int {
        
        let lines = input.components(separatedBy: "\n")        
        let matrix = lines.map { $0.map { String($0) } }
        
        let count = (1...4).reduce((matrix, 0)) { acc, _ in
            let (matrix, total) = acc
            
            let rotatedMatrix = matrix.first!.indices.map { row in
                matrix.indices.reversed().map { column in
                    matrix[column][row]
                }
            }
            
            let rotatedInput = rotatedMatrix.map { $0.joined() }.joined(separator: "\n")
            let lineLength = lines.first!.count
            
            let regex = regexClosure(lineLength)
            let count = rotatedInput.matches(of: regex).count
            
            return (rotatedMatrix, total + count)
        }.1
        
        return count
    }
}
