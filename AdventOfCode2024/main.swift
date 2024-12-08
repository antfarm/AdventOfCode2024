//
//  main.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 01.12.24.
//

import Foundation

typealias Solution = (String) -> String


let days: [Int:[Solution]] = [
    
    1: [Day1.part1, Day1.part2], // 1873376, 18997088
    2: [Day2.part1, Day2.part2], // 306, 366
    3: [Day3.part1, Day3.part2], // 170778545, 82868252
    4: [Day4.part1, Day4.part2], // 2560, 1910
    5: [Day5.part1],             // 6949
    6: [Day6.part1],             // 4559
    7: [Day7.part1, Day7.part2], // 1545311493300, 169122112716571
]


for (day, parts) in days.sorted(by: { $0.key < $1.key }) {
    
    let input = input(forDay: day)
    
    print("Day \(day)")
    
    for (part, solution) in parts.enumerated() {
        print("\tPart \(part + 1): ", solution(input))
    }
}


func input(forDay day: Int) -> String {
    
    let fileUrl = try! FileManager.default.url(for: .developerDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let inputFile = fileUrl.appending(path: "Swift/AdventOfCode2024/AdventOfCode2024/input/input\(day)").appendingPathExtension("txt")
    let contents = try! String(contentsOf: inputFile, encoding: .ascii)
    
    return contents
}
