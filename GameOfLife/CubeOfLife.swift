//
//  CubeOfLife.swift
//  GameOfLife
//
//  Created by Zach Eriksen on 9/16/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import SceneKit

class CubeOfLife: SCNNode {
    var life: [[[Bool]]] = []
    var cellsOfLife: [[[CellOfLife]]] = []
    var size: Int
    var width: CGFloat
    var height: CGFloat
    var isBuilt = false
    
    init(n: Int, width: CGFloat, height: CGFloat) {
        self.size = n
        self.width = width
        self.height = height
        super.init()
        setupLife()
    }
    
    private func setupLife() {
        for _ in (0 ..< size) {
            var plane: [[Bool]] = []
            for _ in (0 ..< size) {
                var row: [Bool] = []
                for _ in (0 ..< size) {
                    row.append(Bool.random())
                }
                plane.append(row)
            }
            life.append(plane)
        }
    }
    
    func build() {
        for x in (0 ..< size) {
            var plane: [[CellOfLife]] = []
            for y in (0 ..< size) {
                var row: [CellOfLife] = []
                for z in (0 ..< size) {
                    let isAlive = life[x][y][z]
                    let nodeWidth = width / CGFloat(size)
                    let nodeHeight = height / CGFloat(size)
                    let cell = CellOfLife(isAlive: isAlive, nodeWidth: nodeWidth, nodeHeight: nodeHeight)
                    cell.position =  SCNVector3((CGFloat(x) * nodeWidth) - width / 2, (CGFloat(y) * nodeHeight) - width / 2, CGFloat(z) * nodeWidth)
                    
                    let node1Pos = SCNVector3ToGLKVector3(cell.position)
                    let node2Pos = SCNVector3ToGLKVector3(SCNVector3(CGFloat(position.x) + nodeWidth / 2, CGFloat(position.y) + nodeHeight / 2, CGFloat(position.z) + nodeWidth / 2))
                    let distance = GLKVector3Distance(node1Pos, node2Pos)
                    let color = UIColor(red: CGFloat(255 - (x * 10)) / 255.0, green: CGFloat(255 - (y * 10)) / 255.0, blue: CGFloat(255 - (z * 10)) / 255.0, alpha: CGFloat(1 - (distance * 2)))
                    
                    cell.color = color
                    addChildNode(cell)
                    row.append(cell)
                }
                plane.append(row)
            }
            cellsOfLife.append(plane)
        }
        isBuilt = true
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func update() {
        for x in (0 ..< size) {
            for y in (0 ..< size) {
                for z in (0 ..< size) {
                    let cell = cellsOfLife[x][y][z]
                    let isAlive = life[x][y][z]
                    cell.isAlive = isAlive
                }
            }
        }
    }
    
    @objc
    func tick() {
        var newGen: [[[Bool]]] = []
        for x in (0 ..< size) {
            var plane: [[Bool]] = []
            for y in (0 ..< size) {
                var row: [Bool] = []
                for z in (0 ..< size) {
                    
                    let neighbors: [Bool?] = [
                        // B, tom
                        get(x-1, y-1, z-1),
                        get(x, y-1, z-1),
                        get(x, y, z-1),
                        get(x, y+1, z-1),
                        get(x+1, y+1, z-1),
                        get(x-1, y+1, z-1),
                        get(x+1, y-1, z-1),
                        get(x-1, y, z-1),
                        get(x+1, y, z-1),
                        // Sides
                        get(x-1, y-1, z),
                        get(x, y-1, z),
                        get(x, y+1, z),
                        get(x+1, y+1, z),
                        get(x-1, y+1, z),
                        get(x+1, y-1, z),
                        get(x-1, y, z),
                        get(x+1, y, z),
                        // Top
                        get(x-1, y-1, z+1),
                        get(x, y-1, z+1),
                        get(x, y, z+1),
                        get(x, y+1, z+1),
                        get(x+1, y+1, z+1),
                        get(x-1, y+1, z+1),
                        get(x+1, y-1, z+1),
                        get(x-1, y, z+1),
                        get(x+1, y, z+1),
                        ]
                    
                    let neighborsSum = neighbors.compactMap { $0 }.map{ $0 ? 1 : 0 }.reduce(0,+)
                    switch neighborsSum {
                    case 0 ... 3:
                        row.append(false)
                    case 4 ... 6:// 8
                        if let isAlive = get(x, y, z) {
                            if isAlive {
                                row.append(true)
                            } else {
                                row.append(neighborsSum == 4)
                            }
                        } else {
                            row.append(false)
                        }
                    default:
                        row.append(false)
                    }
                }
                plane.append(row)
            }
            newGen.append(plane)
        }
        life = newGen
        update()
    }
    
    private func get(_ x: Int, _ y: Int, _ z: Int) -> Bool? {
        if x > 0, y > 0, z > 0, x < size, y < size, z < size {
            let value = life[x][y][z]
            
            return value
        }
        return nil
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
