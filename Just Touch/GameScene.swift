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
        
        setupHome()
//        rocket.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
//
//        let scale = 0.08 * CGRectGetHeight(self.frame) / CGRectGetHeight(rocket.frame)
//
//        rocket.setScale(scale)
//        
//        addChild(rocket)
        
        
    }
    
    private func setupHome(){
        
        let planet = SKSpriteNode(imageNamed: "planet")
        let glow = SKSpriteNode(imageNamed: "glow-planet")
        glow.zPosition = planet.zPosition - 1
        
        let scale = CGRectGetHeight(frame) / CGRectGetHeight(planet.frame)
        planet.setScale(scale)
        
        planet.position = CGPoint(x: CGRectGetMidX(frame),
                                  y: CGRectGetHeight(frame) - ( 70 + CGRectGetHeight(planet.frame) / 2 ))
        
        planet.runAction(SKAction.repeatActionForever(
            SKAction.rotateByAngle( CGFloat( M_PI * 2.0), duration: 120.0)))
        
        planet.addChild(glow)
        
        addChild(planet)
        
        let reachLabel = SKSpriteNode(imageNamed: "REACH")
        reachLabel.zPosition = planet.zPosition + 10
        reachLabel.position = CGPoint(x: CGRectGetMidX(frame),
                                      y: CGRectGetMidY(frame))
        
        addChild(reachLabel)
        
        let moon = SKSpriteNode(imageNamed: "moon")
        moon.zPosition = reachLabel.zPosition
        moon.setScale(0.0)
        moon.position = CGPoint(x: CGRectGetMidX(frame),
                                y: CGRectGetMidY(frame) + 50 + CGRectGetHeight(moon.frame)/2 )
        
        addChild(moon)
        moon.runAction(SKAction.scaleTo(0.6, duration: 0.5))
        
        let moonGlow = SKSpriteNode(imageNamed: "moon-glow")
        moonGlow.zPosition = moon.zPosition + 10
        
        moon.addChild(moonGlow)
        
        moonGlow.alpha = 0.0

        moonGlow.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
            SKAction.group([
                SKAction.fadeOutWithDuration(1.3),
                SKAction.scaleTo(3, duration: 1.3)
                ]),
                SKAction.group([
                    SKAction.fadeInWithDuration(0.0),
                    SKAction.scaleTo(0.0, duration: 0.0)
                    ])
                ])
            ))
        
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
