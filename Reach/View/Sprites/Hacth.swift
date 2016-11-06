//
//  Hacth.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/24/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

enum HacthImageName {

    case blue, yellow, red
}

final class Hatch: SKSpriteNode {

    var glow = SKSpriteNode()
 
    override init(texture: SKTexture!, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)

        let glow = SKSpriteNode(imageNamed: "escotilha-azul-glow")
        glow.position = CGPoint(x: CGRectGetMidX(self.frame),
                                y: CGRectGetMidX(self.frame))
        glow.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.group([
                    SKAction.fadeOutWithDuration(1.3),
                    SKAction.scaleTo(2, duration: 1.3)
                    ]),
                SKAction.group([
                    SKAction.fadeInWithDuration(0.0),
                    SKAction.scaleTo(0.0, duration: 0.0)
                    ])
                ])
            ))
        addChild(glow)

        self.glow = glow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeToColor(color: HacthImageName) {

        switch color {
        case .blue:
            texture = SKTexture(imageNamed: "escotilha-azul")
            glow.texture = SKTexture(imageNamed: "escotilha-azul-glow")
        case .red:
            texture = SKTexture(imageNamed: "escotilha-vermelha")
            glow.texture = SKTexture(imageNamed: "escotilha-vermelha-glow")
        case .yellow:
            texture = SKTexture(imageNamed: "escotilha-amarela")
            glow.texture = SKTexture(imageNamed: "escotilha-amarela-glow")
        }
    }

    convenience init() {
        
        let texture = SKTexture(imageNamed:"escotilha-azul")
        
        let color = UIColor(red: 2.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.init(texture: texture, color: color, size: texture.size())
    }
}