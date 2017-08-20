//
//  Tutorial.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/26/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

final class Tutorial: SKSpriteNode {
    
    var isFinished = false
    
    var layers = [SKSpriteNode]()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: UIColor(), size: size)
        
        layers = [
            SKSpriteNode(imageNamed: "ret-c"),
            SKSpriteNode(imageNamed: "ret-b"),
            SKSpriteNode(imageNamed: "ret-a"),
        ]
        
        let titleTutorial = SKSpriteNode(imageNamed: "Control the speed")
        
        titleTutorial.position = CGPoint(x: size.width/2, y: size.height + 40 + titleTutorial.frame.height)

        titleTutorial.setScale(1.4)

        addChild(titleTutorial)
        
        zPosition = 100
        
        setScale(0.8)
        
        layers.forEach { addChild($0) }
    }
    
    func updateLayersPosition(_ force: CGFloat) {
        
        for (index, layer) in layers.enumerated() {
            
            layer.position = CGPoint(x: 0.0,
                                    y: CGFloat(index) * (1.0 - force) * frame.height / CGFloat(layers.count - 1))
        }
        
        if force > 0.4 && isFinished == false {
            
            isFinished = true
            run(SKAction.fadeOut(withDuration: 3.5), completion: { self.removeFromParent() })
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
