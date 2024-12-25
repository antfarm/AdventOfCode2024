//
//  Day22.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 23.12.24.
//

import Foundation


struct Day22 {
    
    static func part1(_ input: String) -> String {
        
        let secretNumbers = secretNumbers(fromInput: input)
        
        let result = secretNumbers
            .map { calculateSecretNumbers(for: $0, count: 2000).last! }
            .reduce(0, +)

        return String(result)
    }
    

    static func part2(_ input: String) -> String {
        
        let secretNumbers = secretNumbers(fromInput: input)
        
        let offers = secretNumbers.map { n in

            let prices = calculateSecretNumbers(for: n, count: 2000).map { $0 % 10 }
            let changes = zip(prices, prices[1...]).map { $1 - $0 }

            let changesPricePairs = prices[4...].enumerated().map { i, price in
                (changes[i...(i + 3)].map { String($0) }.joined(), price)
            }
            
            return Dictionary(changesPricePairs, uniquingKeysWith: { first, _ in first} )
        }
                
        let allOffers = offers.reduce([:]) { $0.merging($1, uniquingKeysWith: +) }
        let bestOffer = allOffers.values.max()!
        
        return String(bestOffer)
    }
            

    fileprivate static func calculateSecretNumbers(for number: Int, count: Int, numbers: [Int] = []) -> [Int] {
     
        guard count > 0 else { return numbers + [number] }
                
        let next = nextSecretNumber(for: number)
        
        return calculateSecretNumbers(for: next, count: count - 1, numbers: numbers + [number])
    }

    
    fileprivate static func nextSecretNumber(for n: Int) -> Int {
        
        func mix(_ n1: Int, into n2: Int) -> Int {  n1 ^ n2 }
        
        func prune(_ n: Int) -> Int { n & 16777215 } // n & 16777215 == n & (1 << 24 - 1) == n % (1 << 24) == n % 16777216

        let n1 = prune(mix(n  << 6,  into: n )) // n << 6 == n * 64
        let n2 = prune(mix(n1 >> 5,  into: n1)) // n >> 5 == Int(n / 32)
        let n3 = prune(mix(n2 << 11, into: n2)) // n << 11 == n * 2048
        
        return n3
    }

    
    fileprivate static func secretNumbers(fromInput input: String) -> [Int] {
        
        input.split(separator: "\n").map { Int($0)! }
    }
}
