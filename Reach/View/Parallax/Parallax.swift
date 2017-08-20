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
    var lastFrameTime: TimeInterval = 0

    // Speed of Rocket
    var speedGlobal: CGFloat = 0
    
    init(backgrounds: [(String, CGFloat)], size: CGSize) {
        super.init(size: size)

        speedGlobal = 0

        isUserInteractionEnabled = false

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
    
    fileprivate func updateParalax(_ deltaTime: TimeInterval) {
        
        layers.forEach { (layer, speed) in
            
            moveSprite(layer, deltaTime: deltaTime, speed: speed)

            if layer.frame.maxY < self.frame.minY {

                layer.position = CGPoint(x: layer.position.x,
                                        y: layer.position.y + layer.size.height * 2)
            }
        }
    }
    
    func moveSprite(_ sprite: SKSpriteNode, deltaTime: TimeInterval, speed: CGFloat) {
        
        var newposition = sprite.position
        newposition.y -= speed * CGFloat(deltaTime) * speedGlobal
        sprite.position = newposition
    }

    func moveSpriteX(_ sprite: SKSpriteNode, deltaTime: TimeInterval, speed: CGFloat) {

        var newposition = sprite.position
        newposition.x += speed * CGFloat(deltaTime)
        sprite.position = newposition
    }
    
    override func update(_ currentTime: TimeInterval) {

        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }

        updateParalax(currentTime - lastFrameTime)

        lastFrameTime = currentTime
    }

    func setSpeedParallax(_ speed: CGFloat) {

        if speed <= maxSpeedRocket && speed >= minSpeedRocket {
            speedGlobal = speed
        }
    }
    
}
