//
//  Hacth.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/24/16.
//  Copyright © 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit

final class Hatch: SKSpriteNode {
    
 
    override init(texture: SKTexture!, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        
    }
    
    convenience init() {
        
        let texture = SKTexture(imageNamed: "escotilha-azul")
        
        let color = UIColor(red: 2.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.init(texture: texture, color: color, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}