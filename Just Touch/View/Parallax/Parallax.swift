//
//  Parallax.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/21/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

class Parallax: SKScene {
    
    // Layers
    var layers = [(SKSpriteNode, CGFloat)]()
    
    // Time of last frame
    var lastFrameTime: NSTimeInterval = 0

    // Speed of Rocket
    var speedGlobal: CGFloat = 0
    
    init(backgrounds: [(String, CGFloat)], size: CGSize) {
        super.init(size: size)

        var zLayerPosition = CGFloat(-10.0)

        backgrounds.forEach { (imageNamed, speed) in

            let layer = SKSpriteNode(imageNamed: imageNamed)
            let nextLayer = SKSpriteNode(imageNamed: imageNamed)
            
            let scale = size.width / layer.size.width
            
            layer.setScale(scale)
            nextLayer.setScale(scale)

            zLayerPosition -= 1

            layer.zPosition = zLayerPosition
            nextLayer.zPosition = zLayerPosition

            layer.position = CGPoint(x: size.width * 0.5,
                                     y: size.height * 0.5)
            
            nextLayer.position  = CGPoint(x: layer.position.x,
                                          y: layer.position.y + layer.size.height)
            
            self.addChild(layer)
            self.addChild(nextLayer)
            
            self.layers.append((layer, speed))
            self.layers.append((nextLayer, speed))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func updateParalax(deltaTime: NSTimeInterval) {
        
        layers.forEach { (layer, speed) in
            
            moveSprite(layer, deltaTime: deltaTime, speed: speed)

            if layer.frame.maxY < self.frame.minY {

                layer.position = CGPoint(x: layer.position.x,
                                        y: layer.position.y + layer.size.height * 2)
            }
        }
    }
    
    private func moveSprite(sprite: SKSpriteNode, deltaTime: NSTimeInterval, speed: CGFloat) {
        
        var newposition = sprite.position
        newposition.y -= speed * CGFloat(deltaTime) * speedGlobal
        sprite.position = newposition
    }
    
    override func update(currentTime: NSTimeInterval) {

        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }

        updateParalax(currentTime - lastFrameTime)

        lastFrameTime = currentTime
    }
    
}