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

        titleTutorial.position = CGPoint(x: 0.0, y: size.height/2 + 40 + titleTutorial.frame.height)

        isUserInteractionEnabled = true

        addChild(titleTutorial)

        zPosition = 400
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, restated == false {

            let location = touch.location(in: self)

            if location.y < frame.height * 0.15 {
                delegate?.restartGameButton(self)

                restated = true
                run(SKAction.fadeOut(withDuration: 0.02), completion: {
                    self.removeFromParent()
                })
            }
        }
    }

    convenience init(points: Int) {

        let texture = SKTexture(imageNamed: "gameover")
        self.init(texture: texture, color: UIColor.clear, size: texture.size())

        let label = SKLabelNode(text: "\(points)")
        label.fontColor = UIColor.white
        label.zPosition = 100000

        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
