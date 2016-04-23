//
//  GameScene.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/21/16.
//  Copyright (c) 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

let maxSpeedRocket:CGFloat = 10

class GameScene: Parallax {

    var rocket = Rocket()

    override func didMoveToView(view: SKView) {

        /* Setup your scene here */

        rocket.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))

        let scale = 0.08 * CGRectGetHeight(self.frame) / CGRectGetHeight(rocket.frame)

        rocket.setScale(scale)
        
        addChild(rocket)
    }
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

        speedGlobal = (speedGlobal + 1) % maxSpeedRocket
        rocket.setSpeedRocket(speedGlobal)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        super.update(currentTime)
    }
}
