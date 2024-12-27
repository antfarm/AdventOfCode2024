//
//  Day24.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 26.12.24.
//

import Foundation


struct Day24 {
    
    static func part1(_ input: String) -> String {
        
        let initialValues = values(fromInput: input)
        let gates = gates(fromInput: input)

        let values = run(values: initialValues, gates: gates)
        //for (k, v) in values.sorted(by: { $0.0 < $1.0 }) { print("\(k): \(v ? "1" : "0")") }
        
        let zKeys = values.keys.filter { $0.starts(with: "z")}.sorted().reversed()
        let binaryString = zKeys.map { values[$0]! ? "1" : "0"}.joined()
        let result = Int(binaryString, radix: 2)!
        
        return String(result)
    }
    
    
    fileprivate static func run(values: [String: Bool], gates: [(String, String, String, String)]) -> [String: Bool]{
                
        let applicableGates = gates.filter { (key1, _, key2, _) in
            values[key1] != nil && values[key2] != nil
        }
                
        let newKeyValuePairs: [(String, Bool)] = applicableGates.map { (key1, operation, key2, keyResult) in
            
            let value1 = values[key1]!
            let value2 = values[key2]!
            
            let result: Bool!
            
            switch operation {
            case "AND": result = value1 && value2
            case "OR": result = value1 || value2
            case "XOR": result = value1 != value2
            default: result = nil
            }

            return (keyResult, result)
        }
        
        let newValues = values.merging(Dictionary(uniqueKeysWithValues: newKeyValuePairs)) { $1 }
        
        let newGates = gates.filter { (key1, _, key2, _) in
            values[key1] == nil || values[key2] == nil
        }
        
        if newGates.isEmpty { return newValues }
        
        return run(values: newValues, gates: newGates)
    }

    
    fileprivate static func values(fromInput input: String) -> [String: Bool] {
        
        let regex = /([a-z][0-9]{2}): ([01])/
        
        let wiresWithValues = input.matches(of: regex).map { (String($0.1), Int($0.2)! == 1) }
        
        return Dictionary(uniqueKeysWithValues: wiresWithValues)
    }
    

    fileprivate static func gates(fromInput input: String) -> [(String, String, String, String)] {
        
        let regex = /([a-z0-9]{3}) (AND|OR|XOR) ([a-z0-9]{3}) -> ([a-z0-9]{3})/

        let gates = input.matches(of: regex).map { (String($0.1), String($0.2), String($0.3), (String($0.4))) }
        
        return gates
    }
}
