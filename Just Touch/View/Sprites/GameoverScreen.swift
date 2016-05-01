//
//  GameoverScreen.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 5/1/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

final class GameoverScreen: SKSpriteNode {

    var restated = false

    var delegate: GameSceneDelegate? 

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: UIColor(), size: size)

        let titleTutorial = SKSpriteNode(imageNamed: "dave")

        titleTutorial.position = CGPoint(x: 0.0, y: size.height/2 + 40 + CGRectGetHeight(titleTutorial.frame))

        userInteractionEnabled = true

        addChild(titleTutorial)

        zPosition = 400
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first where restated == false {

            let location = touch.locationInNode(self)

            if location.y < CGRectGetHeight(frame) * 0.25 {
                delegate?.restartGameButton(self)

                restated = true
                runAction(SKAction.fadeOutWithDuration(0.02), completion: { 
                    self.removeFromParent()
                })
            }
        }
    }

    convenience init() {

        let texture = SKTexture(imageNamed: "gameover")
        self.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}