//
//  GameScene.swift
//  Just Touch
//
//  Created by Fernando Ferreira on 4/21/16.
//  Copyright (c) 2016 Fernando Ferreira. All rights reserved.
//

import SpriteKit
import CoreMotion

let maxSpeedRocket:CGFloat = 10.0
var minSpeedRocket:CGFloat = 0.2


enum ObjectsBitMask: UInt32 {
    case Rocket = 1
    case Meteor = 2
}

class GameScene: Parallax {

    var tutorial:Tutorial?
    
    let manager = CMMotionManager()

    var objectsInMoviments = [(SKSpriteNode, CGFloat)]()

    var rocket = Rocket()

    var inHome = false
    var inSplashScreen = true

    var gameOver = false
    
    var planet: SKSpriteNode?
    var moon: Moon?
    var reachLabel: SKSpriteNode?
    
    var forceTouchEnable = false

    var currentDistance:CGFloat = 0.0
    var meteorShower = false

    var distanceOfLastMeteor:CGFloat = 0.0
    var distanceBetweenMeteor:CGFloat = 5.0

    var timeOfInitGame:NSTimeInterval = 0.0

    override func didMoveToView(view: SKView) {

        /* Setup your scene here */
        physicsWorld.contactDelegate = self

        backgroundColor = UIColor(red: 25.0/255.0, green: 25/255.0, blue: 25.0/255.0, alpha: 1.0)
        
        setupHome()
    }

    func restartGame() {

        objectsInMoviments.forEach({ $0.0.removeFromParent() })
        objectsInMoviments.removeAll()

        rocket.removeFromParent()
        rocket = Rocket()

        tutorial?.removeFromParent()
        tutorial = nil

        manager.stopDeviceMotionUpdates()

        inHome = false
        inSplashScreen = true

        gameOver = false

        planet?.removeFromParent()
        planet = nil

        moon?.removeFromParent()
        moon = nil

        reachLabel?.removeFromParent()
        reachLabel = nil

        currentDistance = 0.0
        meteorShower = false

        distanceOfLastMeteor = 0.0
        distanceBetweenMeteor = 5.0
        
        timeOfInitGame = 0.0

        setupHome()
    }

    private func setupHome(){

        userInteractionEnabled = true
        
        let planet = SKSpriteNode(imageNamed: "planet")
        let glow = SKSpriteNode(imageNamed: "glow-planet")
        glow.zPosition = planet.zPosition - 1
        
        let scale = CGRectGetHeight(frame) / CGRectGetHeight(planet.frame)
        planet.setScale(scale)
        
        planet.position = CGPoint(x: CGRectGetMidX(frame),
                                  y: CGRectGetHeight(frame) - ( 70 + CGRectGetHeight(planet.frame) / 2 ))
        
        planet.runAction(SKAction.repeatActionForever(
            SKAction.rotateByAngle( CGFloat( M_PI * 2.0), duration: 200.0)))
        
        planet.addChild(glow)
        
        addChild(planet)
        
        let reachLabel = SKSpriteNode(imageNamed: "REACH")
        reachLabel.zPosition = planet.zPosition + 10
        reachLabel.position = CGPoint(x: CGRectGetMidX(frame),
                                      y: 220 + CGRectGetHeight(reachLabel.frame)/2)
        
        addChild(reachLabel)
        
        let moon = Moon(imageNamed: "moon")
        moon.zPosition = reachLabel.zPosition
        moon.setScale(0.0)
        moon.position = CGPoint(x: CGRectGetMidX(frame),
                                y: reachLabel.position.y + 50 + CGRectGetHeight(moon.frame)/2 )
        
        addChild(moon)
        moon.runAction(SKAction.scaleTo(0.6, duration: 0.5))
        
        let moonGlow = SKSpriteNode(imageNamed: "moon-glow")
        moonGlow.zPosition = moon.zPosition + 10
        
        moon.addChild(moonGlow)
        moon.glow = moonGlow

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
        
        self.planet = planet
        self.reachLabel = reachLabel
        self.moon = moon
    }
    
    func initTutorial () {
        
        let myTutorial = Tutorial(texture: nil, color: UIColor.clearColor(), size: CGSize(width: 10, height: CGRectGetHeight(frame) * 0.05))
        
        myTutorial.position = CGPoint(x: CGRectGetMidX(frame),
                                      y: CGRectGetHeight(myTutorial.frame) + 50)
        addChild(myTutorial)
        
        tutorial = myTutorial
    }

    // MARK: - CoreMotion
    func setupCoreMotion() {

        let queue = NSOperationQueue()
        
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data: CMDeviceMotion?, error: NSError?) in
                
                if let gravity = data?.gravity {
                    var rotation = atan2( gravity.x, gravity.y)
                    rotation = rotation > 0 ?
                        max(rotation, M_PI * 0.75) :
                        min(rotation, -M_PI * 0.75)

                    self.applyRotation(CGFloat(rotation - M_PI))
                }
            })
        }
    }

    func applyRotation(rotation: CGFloat){

        rocket.zRotation = rotation
    }

    // MARK: - Touches
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

        guard let currentTouch = touches.first else { return }

        if inSplashScreen {

            inSplashScreen = false
            userInteractionEnabled = false
            startGame()
        } else {

            if meteorShower == false {
                distanceOfLastMeteor = currentDistance + distanceBetweenMeteor * 2
                meteorShower = true
            }

            minSpeedRocket = 3.0
            changeSpeedTo( calculateSpeedWith(currentTouch) )

        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

        guard let currentTouch = touches.first else { return }

        changeSpeedTo( calculateSpeedWith(currentTouch))
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if #available(iOS 9.0, *) {
            if forceTouchEnable {
                
                changeSpeedTo(0.0)
            }
        }
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {

        if #available(iOS 9.0, *) {
            if forceTouchEnable {
                
                changeSpeedTo(0.0)
            }
        }
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        currentDistance += CGFloat(currentTime - lastFrameTime ) * speedGlobal

        updateMovimentObjects(currentTime - lastFrameTime)
        rocket.moveY(currentTime - lastFrameTime, size: frame.size)
        
        super.update(currentTime)

        checkAddOtherMeteor()

        tutorial?.updateLayersPosition(speedGlobal/maxSpeedRocket)

        checkPositionOfRocket()
    }

    private func checkAddOtherMeteor() {

        if meteorShower && currentDistance - distanceOfLastMeteor > distanceBetweenMeteor {
            addMeteorToView()
        }
    }

    private func updateMovimentObjects(deltaTime: NSTimeInterval) {

        objectsInMoviments = objectsInMoviments.filter { (layer, speed) -> Bool in
            self.moveSprite(layer, deltaTime: deltaTime, speed: speed)

            if layer.frame.maxY < self.frame.minY {

                layer.removeFromParent()
                return false
            }
            return true
        }
    }

    private func checkPositionOfRocket(){

        if inHome && rocket.position.y > CGRectGetMidY(frame) {
            rocket.physicsBody?.velocity = CGVector.zero

            inHome = false
            playTheGame()
        }
    }

    private func playTheGame(){

        initTutorial()
        timeOfInitGame = lastFrameTime
        userInteractionEnabled = true
        if let planet = self.planet {
            objectsInMoviments.append((planet, 20.0))
        }
        setupCoreMotion()
    }

    private func addMeteorToView(){

        distanceOfLastMeteor = currentDistance
        let meteor = Meteor()

        let ran = CGFloat(arc4random()) % CGRectGetMaxX(frame)

        meteor.position = CGPoint(x: ran,
                                  y: CGRectGetHeight(frame) + CGRectGetHeight(meteor.frame)/2 )

        let ranSpeed = CGFloat( arc4random() % 30)

        addObjectToView(meteor, speed: 30.0 + ranSpeed)
    }

    private func addObjectToView(object: SKSpriteNode, speed: CGFloat) {

        addChild(object)
        objectsInMoviments.append((object, speed))
    }

    // MARK: - Speed
    private func calculateSpeedWith(touch: UITouch) -> CGFloat {

        if #available(iOS 9.0, *) {
            if forceTouchEnable {

                return touch.force * (maxSpeedRocket - minSpeedRocket) /
                                touch.maximumPossibleForce
            }
        }
        
        let location = touch.locationInNode(self)

        let maxYOfControl = CGRectGetHeight(frame) * 0.2
        let minYOfControl = CGRectGetHeight(frame) * 0.1

        return minSpeedRocket + (max(minYOfControl, min(location.y, maxYOfControl)) - minYOfControl) *
             (maxSpeedRocket - minSpeedRocket) / (maxYOfControl - minYOfControl)
    }

    private func changeSpeedTo(speed: CGFloat) {

        rocket.setSpeedRocket(speed)
        setSpeedParallax(speed)
    }
}

extension GameScene: SKPhysicsContactDelegate {

    func didBeginContact(contact: SKPhysicsContact) {

        if gameOver == false &&
            (contact.bodyA.categoryBitMask == ObjectsBitMask.Rocket.rawValue &&
            contact.bodyB.categoryBitMask == ObjectsBitMask.Meteor.rawValue) {

            if let meteor = contact.bodyB.node as? Meteor {

                meteor.crash()
                rocket.removeLife()
            }

            if rocket.lifes <= 0 {
                gameOver = true
                restartGame()
            }
            //UIAlertView(title: "Perdeu! ", message: "Tempo de jogo: \(lastFrameTime - timeOfInitGame)", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok").show()
        }
    }
}

extension GameScene {
    
    func startGame() {
        guard let planet = planet else { return }

        inHome = true

        setSpeedParallax(3.0)

        rocket.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetHeight(frame) * -0.1)
        let scale = 0.1 * CGRectGetHeight(frame) / CGRectGetHeight(rocket.frame)
        rocket.setScale(scale)
        rocket.smoke.particleAlphaSpeed = 0.3
        rocket.zPosition = planet.zPosition + 2
        rocket.smoke.zPosition = rocket.zPosition - 1

        addChild(rocket)
        rocket.zPosition = planet.zPosition + 1
        rocket.physicsBody?.applyImpulse(CGVector(dx: 0.0,
                                                dy: CGRectGetHeight(frame) * 0.03))

        moon?.glow?.removeAllActions()
        moon?.glow?.setScale(0.5)
        moon?.glow?.alpha = 1.0
        
        moon?.glow?.runAction(SKAction.sequence([
            SKAction.scaleTo(3, duration: 1.5),
            SKAction.scaleTo(0.0, duration: 0.0)
            ]))
        
        moon?.runAction(SKAction.fadeOutWithDuration(1.3))
        
        reachLabel?.runAction(SKAction.fadeOutWithDuration(1.3))
        planet.runAction(SKAction.moveTo(CGPoint(x: planet.position.x, y: CGRectGetHeight(planet.frame) * -0.15), duration: 3.0)) {

            self.setSpeedParallax(0.2)
            self.rocket.smoke.particleAlphaSpeed = -2.0

            if let body = self.rocket.physicsBody {
                body.applyImpulse(CGVector(dx: 0.0, dy: body.velocity.dy * -0.06))
            }
        }
    }
}

