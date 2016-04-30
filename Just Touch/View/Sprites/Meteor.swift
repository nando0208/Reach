//
//  Meteor.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/30/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

final class Meteor: SKSpriteNode {

    override init(texture: SKTexture!, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)

        runAction(SKAction.repeatActionForever(
            SKAction.rotateByAngle( CGFloat( M_PI * 2.0), duration: 50.0)))

        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.categoryBitMask = ObjectsBitMask.Meteor.rawValue
        physicsBody?.contactTestBitMask = ObjectsBitMask.Rocket.rawValue

        physicsBody?.affectedByGravity = false
    }

    convenience init() {

        let ran = arc4random() % 3

        let texture = SKTexture(imageNamed: String(format: "meteor%d", ran))

        let color = UIColor(red: 2.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.init(texture: texture, color: color, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}