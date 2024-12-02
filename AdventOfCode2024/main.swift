//
//  main.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 01.12.24.
//

import Foundation

typealias Solution = (String) -> String


let allSolutions: [Int:[Solution]] = [
    
    1: [Day1.part1, Day1.part2],
    2: [Day2.part1, Day2.part2],
]


for (day, solutions) in allSolutions.sorted(by: { $0.key < $1.key }) {
    
    let input = readInput(forDay: day)
    
    print("Day \(day)")
    
    for (part, solution) in solutions.enumerated() {
        print("\tPart \(part + 1): ", solution(input))
    }
}


func readInput(forDay day: Int) -> String {
    
    let fileUrl = try! FileManager.default.url(for: .developerDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let inputFile = fileUrl.appending(path: "Swift/AdventOfCode2024/AdventOfCode2024/input/input\(day)").appendingPathExtension("txt")
    let contents = try! String(contentsOf: inputFile, encoding: .ascii)
    
    return contents
        // remove newline at end of file that Xcode keeps adding
        .split(whereSeparator: \.isNewline).joined(separator: "\n")
}
