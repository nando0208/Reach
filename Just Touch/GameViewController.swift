//
//  GameViewController.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/21/16.
//  Copyright (c) 2016 Fernando Ferreira. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(backgrounds: [("bg-close",   80.0),
                                            ("bg-far",     40.0),
                                            ("bg-veryfar", 20.0)],
                              size: self.view.frame.size)
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == .Available {
                scene.forceTouchEnable = true
            }
        }
        
        // Configure the view.
        if let skView = self.view as? SKView {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
