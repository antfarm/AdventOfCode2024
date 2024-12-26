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

        let computers = Set(connections.map { [$0.0, $0.1]}.reduce([], +))

        let connectedComputersPairs = computers.map { computer in
            
            let connectedComputers = connections.compactMap { (computer1, computer2) in
                if computer1 == computer { return computer2 }
                if computer2 == computer { return computer1 }
                return nil
            }
            
            return (computer, connectedComputers)
        }

        let connectedComputers = Dictionary(uniqueKeysWithValues: connectedComputersPairs)

        let computersWithT = computers.filter { $0.starts(with: "t") }
        
        let triples = computersWithT.flatMap { computerT in
            
            let connectedToT = connectedComputers[computerT]!
            
            return connectedToT.flatMap { computer1 in
                
                let connectedToT = connectedToT.filter { $0 != computer1 }
                let connectedTo1 = connectedComputers[computer1]!.filter { $0 != computerT }
                let connectedToTAnd1 = Set(connectedToT).intersection(Set(connectedTo1))
                    
                return connectedToTAnd1.map { computer2 in
                    let triple = [computerT, computer1, computer2].sorted()
                    return "\(triple[0])-\(triple[1])-\(triple[2])"
                }
            }
        }
        
        let uniqueTriples = Set(triples)
        
        print(uniqueTriples.sorted())
        
        return String(uniqueTriples.count)
    }
    
    
    fileprivate static func connections(fromInput input: String) -> [(String, String)] {
        
        let regex = /([a-z]{2})\-([a-z]{2})/

        let connections = input.matches(of: regex).map { (String($0.1), String($0.2)) }
        
        return connections
    }
}
