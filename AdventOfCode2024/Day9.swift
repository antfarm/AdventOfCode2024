//
//  Day9.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 09.12.24.
//

import Foundation


struct Day9 {
    
    static func part1(_ input: String) -> String {

        let disk = blocks(fromDiskMap: input)
        let defragmentedDisk = defragmentMutable(disk: disk)
        
        let checksum = checksum(disk: defragmentedDisk)
        
        return String(checksum)
    }
    

    fileprivate static func defragment(disk: [Int]) -> [Int] {
        
        // print(disk.map { "\($0)" }.joined().replacingOccurrences(of: "-1", with: "."))
        
        guard let index = disk.firstIndex(of: -1) else {
            return disk
        }
        
        return defragment(disk: Array(disk[0..<index] + [disk.last!] + disk[index+1..<disk.count-1]))
    }
    
    
    fileprivate static func defragmentMutable(disk: [Int]) -> [Int] {
        
        var mutableDisk = disk
        
        while true {
            guard let index = mutableDisk.firstIndex(of: -1) else {
                break
            }
            
            mutableDisk = Array(mutableDisk[0..<index] + [mutableDisk.last!] + mutableDisk[index+1..<mutableDisk.count-1])
        }
        
        return mutableDisk
    }

    
    fileprivate static func checksum(disk: [Int]) -> Int {
        
        disk.enumerated().reduce(0) { sum, element in
            let (index, id) = element
            return sum + (index * id)
        }
    }
    
    
    fileprivate static func blocks(fromDiskMap input: String) -> [Int] {
        
        let numbers = Array(input).map { Int(String($0))! }
        
        return numbers.enumerated().reduce([Int]()) { blocks, element in
            let (index, number) = element
            
            if index % 2 == 0 {
                let fileId = index / 2
                return blocks + Array(repeating: fileId, count: number)
            }
            else {
                let space = -1
                return blocks + Array(repeating: space, count: number)
            }
        }
    }
}
