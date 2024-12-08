//
//  DayN.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 07.12.24.
//

import Foundation

struct Day7 {
       
    static func part1(_ input: String) -> String {

        let equations: [(Int, [Int])] = equations(fromInput: input)
        let operators = ["+", "*"]
        
        let validEquations = validEquations(equations: equations, operators: operators)
        let result =  validEquations.map { $0.0 }.reduce(0, +)

        return String(result)
    }

    
    static func part2(_ input: String) -> String {

        let equations: [(Int, [Int])] = equations(fromInput: input)
        let operators = ["+", "*", "|"]
        
        let validEquations = validEquations(equations: equations, operators: operators)
        let result = validEquations.map { $0.0 }.reduce(0, +)

        return String(result)
    }


    fileprivate static func validEquations(equations: [(Int, [Int])], operators: [String], debug: Bool = false) -> [(Int, [Int])] {
        
        equations.filter {
            let (expectedResult, operands) = $0
            
            let base = operators.count
            let length = operands.count - 1
            
            let combinationsCount = Int(pow(Double(base), Double(length)))

            return Array(0..<combinationsCount).contains { number in
                
                let digits = String(String(String(number, radix: base).reversed())
                    .padding(toLength: length, withPad: "0", startingAt: 0).reversed())
                
                let operators = digits.map { operators[Int(String($0))!] }
                
                let partialApplications = Array(zip(operators, operands[1...]))
                
                let result = partialApplications.reduce(operands[0]) { result, application in
                    let (op, operand) = application

                    return op == "|" ? Int("\(result)\(operand)")!
                                     : (op == "+" ? (+) : (*))(result, operand)
                }
            
                if debug && result == expectedResult {
                    print("\(expectedResult) = \(partialApplications.reduce("\(operands[0])") { "\($0) \($1.0) \($1.1)" }) = \(result)")
                }

                return result == expectedResult
            }
        }
    }
    
    
    fileprivate static func equations(fromInput input: String) -> [(Int, [Int])] {
        
        let lines = input.split(separator: "\n")
        
        return lines.map { line in
            
            let parts = line.split(separator: ":")
            let result = Int(parts[0])!
            let operands = parts[1].split(whereSeparator: \.isWhitespace).map { Int($0)! }
            
            return (result, operands)
        }
    }
}
