//
//  GameScene.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/21/16.
//  Copyright (c) 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

class GameScene: ParallaxScene {

//    override init(size: CGSize) {
//        super.init(size: size)
//        
//        self.addChild(SKSpriteNode(texture: SKTexture(imageNamed: "bg_close")))
//        self.addChild(SKSpriteNode(texture: SKTexture(imageNamed: "bg_far")))
//        self.addChild(SKSpriteNode(texture: SKTexture(imageNamed: "bg_close")))
//        self.addChild(SKSpriteNode(texture: SKTexture(imageNamed: "bg_far")))
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func didMoveToView(view: SKView) {

        /* Setup your scene here */
        
        let rocket = Rocket()
        
        rocket.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        rocket.yScale = 0.4
        rocket.xScale = 0.4
        
        self.addChild(rocket)
    }
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        super.update(currentTime)
    }
}
