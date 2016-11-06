//
//  Meteor.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/30/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

final class Meteor: SKSpriteNode {

    var ranImage:UInt32 = 0

    override init(texture: SKTexture!, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)

        let ran = arc4random() % 2

        let ranSpeed = Double(arc4random()) % 20

        runAction(SKAction.repeatActionForever(
            SKAction.rotateByAngle( CGFloat( M_PI * 2.0 * (ran == 0 ? -1 : 1)),
                duration: 40.0 + ranSpeed)))

        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.categoryBitMask = ObjectsBitMask.Meteor.rawValue
        physicsBody?.contactTestBitMask = ObjectsBitMask.Rocket.rawValue
        physicsBody?.collisionBitMask = ObjectsBitMask.Meteor.rawValue

        physicsBody?.affectedByGravity = false
    }

    convenience init() {

        let ran = arc4random() % 3

        let texture = SKTexture(imageNamed: String(format: "meteor%d", ran))

        let color = UIColor(red: 2.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.init(texture: texture, color: color, size: texture.size())

        self.ranImage = ran
    }

    func crash(){

        texture = SKTexture(imageNamed: String(format: "meteorcrash%d", self.ranImage))
        physicsBody = nil
        runAction(SKAction.fadeOutWithDuration(0.7), completion: {
            self.position = CGPoint(x: 0.0, y: -1000)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}