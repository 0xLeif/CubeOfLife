//
//  CellOfLife.swift
//  GameOfLife
//
//  Created by Zach Eriksen on 9/16/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import SceneKit

class CellOfLife: SCNNode {
    private let aliveColor = UIColor.white.withAlphaComponent(0.75)
    private var boxNode: SCNNode
    public var color: UIColor? {
        didSet {
            self.boxNode.geometry?.firstMaterial?.diffuse.contents = color ?? aliveColor
        }
        
    }
    public var isAlive: Bool {
        didSet {
            boxNode.isHidden = !isAlive
        }
    }
    
    init(isAlive alive: Bool, nodeWidth: CGFloat, nodeHeight: CGFloat) {
        let box = SCNBox(width: nodeWidth, height: nodeHeight, length: nodeWidth, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = aliveColor
        boxNode = SCNNode(geometry: box)
        isAlive = alive
        super.init()
        addChildNode(boxNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
