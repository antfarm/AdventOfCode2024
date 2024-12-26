//
//  main.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 01.12.24.
//

import Foundation

typealias Solution = (String) -> String


let days: [Int:[Solution]] = [
    
//    1:  [Day1.part1,  Day1.part2],  // 1873376, 18997088
//    2:  [Day2.part1,  Day2.part2],  // 306, 366
//    3:  [Day3.part1,  Day3.part2],  // 170778545, 82868252
//    4:  [Day4.part1,  Day4.part2],  // 2560, 1910
//    5:  [Day5.part1             ],  // 6949
//    6:  [Day6.part1             ],  // 4559
//    7:  [Day7.part1,  Day7.part2],  // 1545311493300, 169122112716571
//    8:  [Day8.part1,  Day8.part2],  // 269, 949
//    9:  [Day9.part1             ],  // 6283170117911
//    10: [Day10.part1, Day10.part2], // 461, 875
//    11: [Day11.part1, Day11.part2], // 216996, 257335372288947
//    12: [Day12.part1,            ], // 1486324
//    13: [Day13.part1, Day13.part2], // 36870, 78101482023732
//    14: [Day14.part1, Day14.part2], // 218619120, 7055
//    15: [Day15.part1             ], // 1413675
//    16: [Day16.part1             ], // ?
//    17: [Day17.part1             ], // 4,1,7,6,4,1,0,2,7
//    18: [Day18.part1, Day18.part2], // 282, 64,29
//    19: [Day19.part1 ,Day19.part2], // 263, 723524534506343
//    20: [Day20.part1, Day20.part2], // 1363, 1007186
//    21: [Day21.part1             ], // 152942
//    22: [Day22.part1, Day22.part2], // 14869099597, 1717
    23: [Day23.part1, Day23.part2], // 1230
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
        // remove newline at end of file that Xcode keeps adding
        .split(whereSeparator: \.isNewline).joined(separator: "\n")}
