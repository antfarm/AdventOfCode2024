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

        let connectedComputers = networkMap(connections: connections)

        let computersWithT = connectedComputers.keys.filter { $0.starts(with: "t") }

        let triples = computersWithT.flatMap { computer1 in
            
            let connectedTo1 = connectedComputers[computer1]!
            
            return connectedTo1.flatMap { computer2 in
                
                let connectedTo1 = connectedTo1.filter { $0 != computer2 }
                let connectedTo2 = connectedComputers[computer2]!.filter { $0 != computer1 }
                let connectedTo1And2 = Set(connectedTo1).intersection(Set(connectedTo2))
                    
                return connectedTo1And2.map { computer3 in
                    let triple = [computer1, computer2, computer3].sorted()
                    return "\(triple[0])-\(triple[1])-\(triple[2])"
                }
            }
        }
        
        let uniqueTriples = Set(triples)
        
        return String(uniqueTriples.count)
    }
    
    
    static func part2(_ input: String) -> String {
        
        let connections = connections(fromInput: input)
        
        let connectedComputers = networkMap(connections: connections)
        
        for computer in connectedComputers.keys.sorted() {
            print("\(computer): \(connectedComputers[computer]!)")
        }
        
        
//        connectedComputers.find { }
        return String(connectedComputers.count)
    }
    

    fileprivate static func networkMap(connections: [(String, String)]) -> [String:[String]] {
        
        let computers = Set(connections.map { [$0.0, $0.1]}.reduce([], +))
        
        let connectedComputersPairs = computers.map { computer in
            
            let connectedComputers = connections.compactMap { (computer1, computer2) in
                if computer1 == computer { return computer2 }
                if computer2 == computer { return computer1 }
                return nil
            }
            
            return (computer, connectedComputers)
        }
        
        return Dictionary(uniqueKeysWithValues: connectedComputersPairs)
    }
    
    
    fileprivate static func connections(fromInput input: String) -> [(String, String)] {
        
        let regex = /([a-z]{2})\-([a-z]{2})/

        let connections = input.matches(of: regex).map { (String($0.1), String($0.2)) }
        
        return connections
    }
}
