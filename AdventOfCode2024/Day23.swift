//
//  Day23..swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 25.12.24.
//


import Foundation


struct Day23 {
    
    static func part1(_ input: String) -> String {
        
        let connections = connections(fromInput: input)
        
        let connectionsByComputer = connections.map { (computer, _) in
            
            let connectedComputers = connections.compactMap { (computer1, computer2) in
                if computer1 == computer { return computer2 }
                if computer2 == computer { return computer1 }
                return nil
            }
            
            return (computer, connectedComputers)
        }
        
        print(connectionsByComputer)
        
        return String(connections.count)
    }
    
    
    fileprivate static func connections(fromInput input: String) -> [(String, String)] {
        
        let regex = /([a-z]{2})\-([a-z]{2})/

        let connections = input.matches(of: regex).map { (String($0.1), String($0.2)) }
        
        return connections
    }
}
