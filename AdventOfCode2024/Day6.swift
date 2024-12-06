//
//  Day6.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 06.12.24.
//

import Foundation


struct Day6 {
    
    static func part1(_ input: String) -> String {
        
        let lines = input.split(separator: "\n")
        
        let world = String(repeating: "@", count: lines[0].count + 2) + "\n"
                  + lines.map { "@\($0)@" }.joined(separator: "\n") + "\n"
                  + String(repeating: "@", count: lines[0].count + 2)
        
        let finalWorld = stepUntilLeavingWorld(world: world)
        
        let count = finalWorld.matches(of: /X/).count
        
        return String(count)
    }
    
    
    fileprivate static func stepUntilLeavingWorld(world: String, debug: Bool = false) -> String {
        if debug { print("\(world)\n") }

        if world.contains(/\$/) {
            return world
        }

        let rotationCount = [ ">", "\\^", "<", "v" ].firstIndex(where: { world.contains(try! Regex($0)) })!
        let rotatedWorld = rotateClockwise(world: world, count: rotationCount)
        
        let change = [
            (">@", "X$"), // leave the world
            (">#", "v#"), // turn right at obstacle
            (">X", "X>"), // walk over already visited position
            (">.", "X>")  // walk over never visited position, mark visited (last due to dot in regex)
        ].first {
            rotatedWorld.contains(try! Regex($0.0))
        }!
              
        let newRotatedWorld = rotatedWorld.replacingOccurrences(of: change.0, with: change.1)
        let newWorld = rotateClockwise(world: newRotatedWorld, count: debug ? 4 - rotationCount : 0)
        
        return stepUntilLeavingWorld(world: newWorld, debug: debug)
    }
    
    
    fileprivate static func rotateClockwise(world: String, count: Int) -> String {
        
        guard count > 0 else { return world }
        
        let rows = world.split(separator: "\n")
        let matrix = rows.map { $0.map { String($0) } }
        
        let rotatedMatrix = (1...count).reduce(matrix) { (matrix, _) in
            matrix.first!.indices.map { row in
                matrix.indices.reversed().map { column in
                    matrix[column][row]
                }
            }
        }
        
        let rotatedWorld = rotatedMatrix.map { $0.joined() }.joined(separator: "\n")
        
        guard let headingIndex = [">", "v", "<", "\\^"].firstIndex(where: { world.contains(try! Regex($0)) }) else {
            return rotatedWorld
        }
        
        let headings = [">", "v", "<", "^"]
        let heading = headings[headingIndex]
        let rotatedHeading = headings[(headingIndex + count) % 4]
        
        return rotatedWorld.replacingOccurrences(of: heading, with: rotatedHeading)
    }
}
