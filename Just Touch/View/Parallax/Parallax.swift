//
//  Parallax.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/21/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

class ParallaxScene: SKScene {
    
    // Layers
    var layers = [(SKSpriteNode, CGFloat)]()
    
    // Time of last frame
    var lastFrameTime : NSTimeInterval = 0
    
    // Time since last frame
    var deltaTime : NSTimeInterval = 0
    
    
    init(backgrounds: [String], size: CGSize) {
        super.init(size: size)
        
        backgrounds.forEach { imageNamed in
            
            let layer = SKSpriteNode(imageNamed: imageNamed)
            let nextLayer = SKSpriteNode(imageNamed: imageNamed)
            
            let scale = size.height / layer.size.height
            
            layer.setScale(scale)
            nextLayer.setScale(scale)
            
            layer.position = CGPoint(x: size.width * 0.5,
                                     y: size.height * 0.5)
            
            nextLayer.position  = CGPoint(x: layer.position.x + layer.size.width,
                                          y: layer.position.y)
            
            self.addChild(layer)
            self.addChild(nextLayer)
            
            self.layers.append((layer, 10.0))
            self.layers.append((nextLayer, 10.0))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func updateParalax(deltaTime: NSTimeInterval) {
        
        layers.forEach { (layer, speed) in
            
            moveSprite(layer, deltaTime: deltaTime, speed: speed)
            
            // If this sprite is now offscreen (i.e., its rightmost edge is
            // farther left than the scene's leftmost edge):
            if layer.frame.maxX < self.frame.minX {
                
                // Shift it over so that it's now to the immediate right
                // of the other sprite.
                // This means that the two sprites are effectively
                // leap-frogging each other as they both move.
                layer.position =
                    CGPoint(x: layer.position.x +
                        layer.size.width * 2,
                        y: layer.position.y)
            }
        }
    }
    
    private func moveSprite(sprite: SKSpriteNode, deltaTime: NSTimeInterval, speed: CGFloat) {
        
        var newposition = sprite.position
        newposition.x -= speed * CGFloat(deltaTime)
        sprite.position = newposition
    }
    
    override func update(currentTime: NSTimeInterval) {
        // First, update the delta time values:
        
        // If we don't have a last frame time value, this is the first frame,
        // so delta time will be zero.
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        // Set last frame time to current time
        lastFrameTime = currentTime
        
        updateParalax(currentTime - lastFrameTime)
    }
    
}