//
//  Day25.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 27.12.24.
//

import Foundation


struct Day25 {
    
    static func part1(_ input: String) -> String {

        let locks = locks(fromInput: input)
        let keys = keys(fromInput: input)

        let count = locks.map { lock in
            keys.count { key in
                zip(lock, key).allSatisfy { (lockPins, keyPins) in
                    lockPins + keyPins <= 5
                }
            }
        }.reduce(0, +)

        return String(count)
    }

    
    fileprivate static func locks(fromInput input: String) -> [[Int]] {
        
        let regex = /#{5}\n([#\.]{5})\n([#\.]{5})\n([#\.]{5})\n([#\.]{5})\n([#\.]{5})\n\.{5}/

        let locks = input.matches(of: regex).map { match in
            
            let rows = [match.1, match.2, match.3, match.4, match.5].map { Array(String($0)) }
            let columns = rows[0].indices.map { i in rows.map { row in row[i] } }
            
            return columns.map { column in column.count { $0 == "#" }}
        }
        
        return locks
    }
    
    
    fileprivate static func keys(fromInput input: String) -> [[Int]] {
        
        let regex = /\.{5}\n([#\.]{5})\n([#\.]{5})\n([#\.]{5})\n([#\.]{5})\n([#\.]{5})\n#{5}/

        let keys = input.matches(of: regex).map { match in
            
            let rows = [match.1, match.2, match.3, match.4, match.5].map { Array(String($0)) }
            let columns = rows[0].indices.map { i in rows.map { row in row[i] } }
            
            return columns.map { column in 5 - column.count { $0 == "." }}
        }

        return keys
    }
}
