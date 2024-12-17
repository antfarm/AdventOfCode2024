//
//  Day17.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 17.12.24.
//

import Foundation


struct Day17 {
    
    static func part1(_ input: String) -> String {
    
        let (registers, program) = debugInfo(fromInput: input)
        
        let output = execute(program: program, registers: registers)
            .map { String($0) }.joined(separator: ",")
        
        return String(output)
    }
    
    
    fileprivate static func execute(program: [Int], registers: (Int, Int, Int), pointer: Int = 0, output: [Int] = []) -> [Int] {
        
        if pointer > program.count - 2 {
            return output
        }
        
        let opcode = program[pointer]
        let operand = program[pointer + 1]
                
        let (a, b, c) = registers
        
        func combo(_ operand: Int) -> Int! {
            switch operand {
            case 0, 1, 2, 3: return operand
            case 4: return a
            case 5: return b
            case 6: return c
            default: return nil
            }
        }

        let registers2: (Int, Int, Int)!
        let pointer2: Int!
        let output2: [Int]!
        
        switch opcode {
        case 0: // adv
            let a2 = a / Int(pow(Double(2), Double(combo(operand))))
            registers2 = (a2, b, c)
            pointer2 = pointer + 2
            output2 = output
            
        case 1: // bxl
            let b2 = b ^ operand
            registers2 = (a, b2, c)
            pointer2 = pointer + 2
            output2 = output
        
        case 2: // bst
            let b2 = combo(operand) % 8
            registers2 = (a, b2, c)
            pointer2 = pointer + 2
            output2 = output
        
        case 3: //jnz
            registers2 = (a, b, c)
            pointer2 = (a == 0) ? pointer + 2 : operand
            output2 = output
            
        case 4: // bxc
            let b2 = b ^ c
            registers2 = (a, b2, c)
            pointer2 = pointer + 2
            output2 = output
            
        case 5: // out
            registers2 = (a, b, c)
            pointer2 = pointer + 2
            output2 = output + [combo(operand) % 8]
            
        case 6: // bdv
            let b2 = a / Int(pow(Double(2), Double(combo(operand))))
            registers2 = (a, b2, c)
            pointer2 = pointer + 2
            output2 = output
        
        case 7: // cdv
            let c2 = a / Int(pow(Double(2), Double(combo(operand))))
            registers2 = (a, b, c2)
            pointer2 = pointer + 2
            output2 = output
        
        default:
            registers2 = nil
            pointer2 = nil
            output2 = nil
        }
        
        return execute(program: program, registers: registers2, pointer: pointer2, output: output2)
    }
    
    
    fileprivate static func debugInfo(fromInput input: String) -> ((Int, Int, Int), [Int]) {
        
        let regex = /Register A: ([0-9]+)\nRegister B: ([0-9]+)\nRegister C: ([0-9]+)\nProgram: (.*)/
        let match = input.firstMatch(of: regex)!
        
        let registers = (Int(match.1)!, Int(match.2)!, Int(match.3)!)
        let program = match.4.split(separator: ",").map { Int($0)! }
        
        return (registers, program)
    }
}
