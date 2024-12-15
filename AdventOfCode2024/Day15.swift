//
//  Day15.swift
//  AdventOfCode2024
//
//  Created by Sean Buttinger on 15.12.24.
//

import Foundation


struct Day15 {
    
    static let columnCount = 50,
               rowCount = columnCount
    

    static func part1(_ input: String) -> String {
        
        let grid = grid(fromInput: input)
        let moves = moves(fromInput: input)
        
        let coordinates = coordinates(columnCount: columnCount, rowCount: rowCount)
        
        let robot = coordinates.filter { (x, y) in grid[x][y] == "@" }.first!
        let boxes = coordinates.filter { (x, y) in grid[x][y] == "O" }
        let walls = coordinates.filter { (x, y) in grid[x][y] == "#" }
        
        let (_, boxesFinal) = moveRobot(robot: robot, boxes: boxes, walls: walls, moves: moves)
        
        let gpsCoordinates = boxesFinal.map { (boxX, boxY) in
            boxX + 100 * (boxY)
        }
        
        let result = gpsCoordinates.reduce (0, +)
        
        return String(result)
    }
    

    fileprivate static func moveRobot(robot: (Int, Int), boxes: [(Int, Int)], walls: [(Int, Int)], moves: [Character]) -> ((Int, Int), [(Int, Int)]) {
        
        //print(toString(robot: robot, boxes: boxes, walls: walls, columnCount: columnCount, rowCount: rowCount))
        
        guard moves.count > 0 else { return (robot, boxes) }
        
        let move = ["^": (0, -1), ">": (1, 0), "v": (0, 1), "<": (-1, 0)][moves.first!]!
        
        let target = (robot.0 + move.0, robot.1 + move.1)
        
        let robotNext: (Int, Int)
        let boxesNext: [(Int, Int)]
        
        if boxes.contains(where: { target.0 == $0.0 && target.1 == $0.1 }) {
            if let boxSwap = pushBox(box: target, move: move, boxes: boxes, walls: walls) {
                robotNext = target
                boxesNext = boxes.map { box in (box.0 == target.0 && box.1 == target.1) ? boxSwap : box }
            }
            else {
                robotNext = robot
                boxesNext = boxes
            }
        }
        else if walls.contains(where: { target.0 == $0.0 && target.1 == $0.1 }) {
            robotNext = robot
            boxesNext = boxes
        }
        else {
            robotNext = target
            boxesNext = boxes
        }
        
        return moveRobot(robot: robotNext, boxes: boxesNext, walls: walls, moves: Array(moves[1...]))
    }
    
    
    // To push a row of boxes, simply swap the directly pushed box with the first empty space in
    // the pushing direction.
        
    fileprivate static func pushBox(box: (Int, Int), move: (Int, Int), boxes: [(Int, Int)], walls: [(Int, Int)]) -> (Int, Int)? {
        
        let target = (box.0 + move.0, box.1 + move.1)
        
        if walls.contains(where: { target.0 == $0.0 && target.1 == $0.1 }) {
            return nil
        }

        if boxes.contains(where: { target.0 == $0.0 && target.1 == $0.1 }) {
            return pushBox(box: target, move: move, boxes: boxes, walls: walls)
        }
        
        return target
    }
    
    
    fileprivate static func grid(fromInput input: String) -> [[Character]] {
        
        let lines = input.split(separator: "\n")[0..<rowCount]
        
        let rows = lines.map { line in Array(line).map { $0 } }
        let columns: [[Character]] = rows[0].indices.map { i in rows.map { line in line[i] } }
        
        return columns
    }
        
        
    fileprivate static func moves(fromInput input: String) -> [Character] {
        
        let lines = input.split(separator: "\n")[rowCount...]
        let moves = Array(lines.joined())
        
        return moves
    }
    
    
    fileprivate static func coordinates(columnCount: Int, rowCount: Int) -> [(Int, Int)] {
        
        let columns = 0..<columnCount
        let rows = 0..<rowCount
        
        return rows.reduce([]) { coords, y in
            coords + columns.map { x in [(x, y)] }.reduce([], +)
        }
    }


    fileprivate static func toString(robot: (Int, Int), boxes: [(Int, Int)], walls: [(Int, Int)], columnCount: Int, rowCount: Int) -> String {
           
        let coordinates = coordinates(columnCount: columnCount, rowCount: rowCount)
        
        let cells = coordinates.reduce("") { cells, coords in
            let (x, y) = coords
            
            let cell =
                x == robot.0 && y == robot.1 ? "@"
                : boxes.contains { x == $0.0 && y == $0.1 } ? "O"
                : walls.contains { x == $0.0 && y == $0.1 } ? "#"
                : "."
            
            return cells + cell + (x % columnCount == columnCount - 1 ? "\n" : "")
        }
        
        return cells
    }
}

/**
 ##################################################
 ##.OOOO.O#O.......#...OO.....O......O..O...OO...O#
 #O.O#........#.#O......O....O.O.....#.#.......#..#
 #O##O....#.O..O.....OOO.#O#.O...............OOO..#
 #.OO#...OO.......OO.OO..OO.O.....OO..O........OO.#
 #.#O..O#OO.......O#O.O#.OO#O...OOOO..OO....O..#O.#
 #......O#.....#..#O...OO...#...O...OO...###O#O.OO#
 #.......O...OOO..........OOO..O..O.O..O..OO.O..O##
 #..#.....OOOO...O...O.........#O......O..OO......#
 #O.....O.O#O...........O.......OO.......#......O##
 ##..O..O.#OOO#....#O...#.....O.O...#..O......#..##
 #.O#...O...##O.....O......#.#O.O...O...#...#.O..O#
 ##OOO..O.................OO....O#.........O...O.O#
 #.##OOOO................O..#.##..OOOO#..........O#
 #O...O#.O..O.OO.....#O..O#OOO....O..OO...O....#O.#
 #.#OOO...O........O..O.O.O#OO....OO.......#O...O.#
 ##.O.......#O....O#O....OOOO#.....O..O....O#O.#.O#
 #..O.....OOO#O...OO...O...............O....OOOOOO#
 #OO.......O..O.O.#...#OO............OO#...#O.O...#
 #OO.......O....O.#O..OOO..........OOO#O.....O#O..#
 #O.......OOO..........#OO........O...O..O.O...#O.#
 #OO.....#O..O...#.....O..........#.............OO#
 #.#.....#O#OOO...........#.........O..O...#.....O#
 #.OOO....OO#O.....OOO#.#.#.OO........O#....O#....#
 #.O.OO..#.#..O..O#OO.#.#O........#...#O....O...OO#
 #O.........O.O...O#OO..........OOO.#.OOO.........#
 #..O......O#....O..O.O#........OOOOO..O...#.#....#
 #O.OO.....#OO.................OO#OOO......OOO....#
 #O#O.......O......O....OOO.....O..OOOO...........#
 #.O.......OO.....#O......O.....#....#O........O..#
 #.O...........@..OO......O..O..#....O...........O#
 #OO..OOO.............O.......#O...#.............O#
 #OO.O..OOOOO#..O..........O..O#O..#....#..#.....O#
 #.O.#O#OO##OO...O...OOO#O.OO.#.....O.....OO...OOO#
 #OO....OOO#OOOO.#....O#...OOO#....OO#...O#OO..OOO#
 #O#....OOOO#OOO.....#..O#...OO....O#O.O........O##
 #O.....##OO....#.......OOO#.OO.###.............OO#
 #O....O#OOO......#..#......OO...O#.........O..OO.#
 #O.....O......#.........O...O.O....OO......#...#O#
 #O..#......#...OO..OOOO.......OOO......O..O......#
 #O..O................#OO...O..#..............O.OO#
 #OO......O.........OO##.....OOO...#..........OO#.#
 ##O..........##O#OO......O...#O..O.........O#O...#
 #OO..#....#..O#..##............O..O..#....O.#O...#
 #.O.....#.O....OOOOO..#....O.#......O.OO.#..O.O..#
 #.#O...........O#OOO.......#..........OO......OO.#
 #OOO......OO.........#.#........O...........##..##
 #OO....OOOOOOOO..........O....OOO.......OOOOOOO..#
 #..O#.OO#O#OOO.#OO.....OOOOO##OO...OOO#OOOO.#..O.#
 ##################################################
 */
