//
//  moon.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/23/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

final class Moon: SKSpriteNode {
    
    var delegate: GameSceneDelegate?
    
    var glow: SKSpriteNode?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        delegate?.startGame()
    }
}
