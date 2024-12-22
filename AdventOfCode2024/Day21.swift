//
//  Day21.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 21.12.24.
//

import Foundation


struct Day21 {
    
    static func part1(_ input: String) -> String {
        
        let codes = codes(fromInput: input)
        
        let complexities = codes.map { code in
            
            let sequence1Options = shortestNumericKeypadSequences(generatingCode: code)
            let sequence2Options = sequence1Options.flatMap { shortestDirectionalKeypadSequences(generatingSequence: $0) }
            let sequenceOptions = sequence2Options.flatMap { shortestDirectionalKeypadSequences(generatingSequence: $0) }

            let shortestLength = sequenceOptions.map { $0.count }.min()!
            let number = Int(code.firstMatch(of: /[0-9]+/)!.0)!
            
            //print("\(code): \(number) * \(shortestLength)")

            return shortestLength * number
        }
        
        let sum = complexities.reduce(0, +)
        
        return String(sum)
    }
    

    fileprivate static func shortestNumericKeypadSequences(generatingCode code: String) -> [String] {

        shortestSequences(generatingSequence: "A" + code, onKeypad: "789|456|123| 0A")
    }
    
    
    fileprivate static func shortestDirectionalKeypadSequences(generatingSequence sequence: String) -> [String] {

        shortestSequences(generatingSequence: "A" + sequence, onKeypad: " ^A|<v>")
    }
    

    fileprivate static func shortestSequences(generatingSequence sequence: String, onKeypad keypad: String) -> [String] {
        
        let transitions = transitions(inKeypad: keypad)
        let keyPairs = zip(sequence, sequence.dropFirst())
        
        let keyPairSequences = keyPairs.map { keyPair in
            let (key1, key2) = keyPair        
            return shortestSequences(from: key1, to: key2, transitions: transitions)
        }
         
        let allCombinations = keyPairSequences.reduce([[]]) { combinations, sequences in
            combinations.flatMap { combination in
                sequences.map { sequence in combination + [sequence] }
            }
        }
        
        // A      0      2                      9       A
        // [["<"], ["^"], [">^^", "^>^", "^^>"], ["vvv"]]
        // => ["<A^A>^^AvvvA", "<A^A^>^AvvvA", "<A^A^^>AvvvA"]
        
        let sequences = allCombinations.map { $0.joined(separator: "A") + "A" }
        
        return sequences
    }
        
    
    fileprivate static func shortestSequences(from key1: Character, to key2: Character, transitions:  [(Character, Character, Character)]) -> [String] {

        func allPaths(paths: [[Character]], found: [[Character]] = []) -> [String] {

            if paths.isEmpty {
                return found.map { String($0) }
            }
            
            let foundPaths = paths.filter { path in path.last == key2 }
            let activePaths = paths.filter { path in path.last != key2}

            let nextPaths = activePaths.flatMap { path in
                transitions
                    .filter { (from, _, _) in from == path.last! }
                    .filter { (_, _, to) in !path.contains { $0 == to }}
                    .map { (_, _, to) in path + [to] }
            }
                                    
            return allPaths(paths: nextPaths, found: found + foundPaths)
        }
        
        let paths = allPaths(paths: [[key1]])
        
        let shortestLength = paths.map { $0.count }.min()!
        let shortestPaths = paths.filter { $0.count == shortestLength }
        let shortestSequences = shortestPaths.map { sequence(forPath: $0, transitions: transitions) }

        return shortestSequences
    }

    
    fileprivate static func sequence(forPath path: String, transitions: [(Character, Character, Character)]) -> String {
        
        let pairs = zip(path, path.dropFirst())
        
        let sequence = pairs.map { key1, key2 in
            let transition = transitions.first { (from, _, to) in from == key1 && to == key2 }!
            let (_, key, _) = transition
            return key
        }
        
        return String(sequence)
    }
    

    fileprivate static func transitions(inKeypad keypad: String) -> [(Character, Character, Character)] {

        let keypad = grid(fromKeypad: keypad)
        let coordinates = coordinates(inGrid: keypad).filter { x, y in keypad[x][y] != " " }
        
        let moves = ["^": (0, -1), "<": (-1, 0), ">": (1, 0), "v": (0, 1)]
    
        return coordinates.flatMap { x, y in
            
            let legalMoves = moves.filter { _, offset in
                let (dx, dy) = offset
                return coordinates.contains { $0 == (x + dx, y + dy) }
            }
                
            let transitions = legalMoves.map { move, offset in
                let (dx, dy) = offset
                return (keypad[x][y], Character(move), keypad[x + dx][y + dy]) // (from, key, to)
            }
            
            return transitions
        }
    }
    
    
    fileprivate static func coordinates(inGrid grid: [[Character]]) -> [(Int, Int)] {
        
        let columns = grid.indices
        let rows = grid[0].indices
        
        return rows.reduce([]) { coords, y in
            coords + columns.map { x in [(x, y)] }.reduce([], +)
        }
    }

    
    fileprivate static func grid(fromKeypad keypad: String) -> [[Character]] {
        
        let lines = keypad.split(separator: "|")
        
        let rows = lines.map { line in Array(line).map { $0 } }
        let columns: [[Character]] = rows[0].indices.map { i in rows.map { line in line[i] } }
        
        return columns
    }

    
    fileprivate static func codes(fromInput input: String) -> [String] {
        
        input.split(separator: "\n").map { String($0) }
    }
    
    
    fileprivate static func toString(keypad: [[Character]]) -> String {
           
        coordinates(inGrid: keypad).reduce("") { keys, coords in
            let (x, y) = coords
            return keys + [keypad[x][y]] + (x % keypad.count == keypad.count - 1 ? "\n" : "")
        }
    }
}

/*
    Sequence            Sequence 2          Sequence 1          Code                 029A:
 
        +---+---+           +---+---+           +---+---+       +---+---+---+
        | ^ | A |           | ^ | A |           | ^ | A |       | 7 | 8 | 9 |        A[0][2]58[9]63[A] <A^A^^>AvvvA
    +---+---+---+   >   +---+---+---+   >   +---+---+---+   >   +---+---+---+
    | < | v | > |       | < | v | > |       | < | v | > |       | 4 | 5 | 6 |        A[0][2]56[9]63[A] <A^A^>^AvvvA
    +---+---+---+       +---+---+---+       +---+---+---+       +---+---+---+
                                                                | 1 | 2 | 3 |        A[0][2]36[9]63[A] <A^A>^^AvvvA
                                                                +---+---+---+
                                                                    | 0 | A |
                                                                    +---+---+

    [("^", ">", "A"), ("^", "v", "<"),                          [("7", ">", "8"), ("7", "v", "4"),
     ("A", "<", "^"), ("A", "v", "v"),                           ("8", "<", "7"), ("8", ">", "9"), ("8", "v", "5"),
     ("<", ">", "v"), ("<", "^", "^"),                           ("9", "<", "8"), ("9", "v", "6"),
     ("v", ">", ">"), ("v", "<", "<"), ("v", "^", "A"),          ("4", "v", "1"), ("4", ">", "5"), ("4", "^", "7"),
     (">", "<", "v")]                                            ("5", "^", "8"), ("5", ">", "6"), ("5", "<", "4"), ("5", "v", "2"),
                                                                 ("6", "<", "5"), ("6", "v", "3"), ("6", "^", "9"),
                                                                 ("1", ">", "2"), ("1", "^", "4"),
     (from, key, to)                                             ("2", "^", "5"), ("2", ">", "3"), ("2", "<", "1"), ("2", "v", "0"),
                                                                 ("3", "<", "2"), ("3", "v", "A"), ("3", "^", "6"),
                                                                 ("0", ">", "A"), ("0", "^", "2"),
                                                                 ("A", "<", "0"), ("A", "^", "3")]
*/
