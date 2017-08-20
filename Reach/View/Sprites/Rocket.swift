//
//  Rocket.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/21/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

final class Rocket: SKSpriteNode {

    fileprivate var speedRocket: CGFloat = 0

    var maxSpeedAlpha: CGFloat = -0.1
    var minSpeedAlpha: CGFloat = -2.0

    var hatch = Hatch()

    var smoke = SKEmitterNode()

    var lifes = 3

    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)

        guard let somkePath = Bundle.main.path(forResource: "SmokeRocket", ofType: "sks"),
            let smokeNode = NSKeyedUnarchiver.unarchiveObject(withFile: somkePath) as? SKEmitterNode else {
                return
        }

        smokeNode.setScale(CGFloat(0.34)) //Scale of Rocket
        smokeNode.position = CGPoint(x: self.frame.midX,
                                     y: self.frame.minY)

        addChild(smokeNode)

        smoke = smokeNode
        maxSpeedAlpha = smokeNode.particleAlphaSpeed
        smokeNode.particleAlphaSpeed = minSpeedAlpha

        addChild(hatch)

        hatch.zPosition = zPosition + 30
        hatch.position = CGPoint(x: self.frame.midX,
                                 y: self.frame.height
                                    - ( hatch.frame.height / 2 ) - self.frame.height * 0.66 )

        hatch.glow.zPosition = hatch.zPosition + 1

        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.categoryBitMask = ObjectsBitMask.rocket.rawValue
        physicsBody?.contactTestBitMask = ObjectsBitMask.meteor.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.affectedByGravity = false
    }

    convenience init() {

        let texture = SKTexture(imageNamed: "rocket")
        self.init(texture: texture, color: UIColor.clear, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSpeedRocket(_ newValue: CGFloat) {

        if newValue <= maxSpeedRocket && newValue >= minSpeedRocket {
            speedRocket = newValue
            smoke.particleAlphaSpeed = minSpeedAlpha - ((minSpeedAlpha - maxSpeedAlpha) * speedRocket / (maxSpeedRocket - 0.2))
        }
    }

    func removeLife() {

        lifes -= 1

        switch lifes {
        case 1:
            hatch.changeToColor(.red)
        case 2:
            hatch.changeToColor(.yellow)
        case 3:
            hatch.changeToColor(.blue)
        default: break
        }
    }

    func moveY(_ deltaTime: TimeInterval, size: CGSize) {

        var rotation = zRotation + .pi

        let margin = size.width * 0.1

        rotation = rotation > 0 ? rotation - .pi : rotation + .pi

        var newPosition = position
        newPosition.x -= 340 * rotation * CGFloat(deltaTime)

        if margin < newPosition.x && newPosition.x < size.width - margin {
            position = newPosition
        }
    }
}
