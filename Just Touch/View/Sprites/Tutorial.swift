//
//  Tutorial.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/26/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

final class Tutorial: SKSpriteNode {
    
    var layers = [SKSpriteNode]()
    
    var force: CGFloat = 0.0
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        layers = [
            SKSpriteNode(imageNamed: "ret-c"),
            SKSpriteNode(imageNamed: "ret-b"),
            SKSpriteNode(imageNamed: "ret-a"),
        ]
        
        zPosition = 100
        
        layers.forEach { addChild($0) }
    }
    
    func updateLayersPosition() {
        
        for (index, layer) in layers.enumerate() {
            
            layer.position = CGPoint(x: CGRectGetMidX(frame),
                                    y: CGFloat(index) * (1.0 - force) * CGRectGetHeight(frame) / CGFloat(layers.count - 1))
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}