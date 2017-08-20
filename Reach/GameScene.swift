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
    case rocket = 1
    case meteor = 2
}

protocol GameSceneDelegate {

    func restartGameButton(_ menu: GameoverScreen)
}

class GameScene: Parallax {

    var tutorial:Tutorial?
    
    let manager = CMMotionManager()

    var objectsInMoviments = [(SKSpriteNode, CGFloat, CGFloat)]()

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

    var timeOfInitGame:TimeInterval = 0.0

    var gameOverScene: GameoverScreen?

    override func didMove(to view: SKView) {

        /* Setup your scene here */
        physicsWorld.contactDelegate = self

        backgroundColor = UIColor(red: 25.0/255.0, green: 25/255.0, blue: 25.0/255.0, alpha: 1.0)
        
        setupHome()
    }

    func gameOverView() {

        minSpeedRocket = 0.0
        changeSpeedTo(0.1)
        manager.stopDeviceMotionUpdates()
        rocket.zRotation = 0

        let menu = GameoverScreen(points: Int(currentDistance * 100000 / CGFloat(lastFrameTime)))
        menu.position = CGPoint(x: frame.midX,
                                y: frame.midY)
        menu.zPosition = rocket.hatch.glow.zPosition + 4000
        menu.delegate = self
        addChild(menu)

        gameOverScene = menu
    }

    func restartGame() {

        objectsInMoviments.forEach({ $0.0.removeFromParent() })
        objectsInMoviments.removeAll()

        rocket.removeFromParent()
        rocket = Rocket()
        rocket.zRotation = 0

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

        minSpeedRocket = 0.2
        setSpeedParallax(0.2)

        setupHome()
    }

    fileprivate func setupHome(){

        isUserInteractionEnabled = true
        
        let planet = SKSpriteNode(imageNamed: "planet")
        let glow = SKSpriteNode(imageNamed: "glow-planet")
        glow.zPosition = planet.zPosition - 1
        
        let scale = frame.height / planet.frame.height
        planet.setScale(scale)
        
        planet.position = CGPoint(x: frame.midX,
                                  y: frame.height - ( 70 + planet.frame.height / 2 ))
        
        planet.run(SKAction.repeatForever(
            SKAction.rotate( byAngle: CGFloat( .pi * 2.0), duration: 200.0)))
        
        planet.addChild(glow)
        
        addChild(planet)
        
        let reachLabel = SKSpriteNode(imageNamed: "REACH")
        reachLabel.zPosition = planet.zPosition + 10
        reachLabel.position = CGPoint(x: frame.midX,
                                      y: 220 + reachLabel.frame.height/2)
        
        addChild(reachLabel)
        
        let moon = Moon(imageNamed: "moon")
        moon.zPosition = reachLabel.zPosition
        moon.setScale(0.0)
        moon.position = CGPoint(x: frame.midX,
                                y: reachLabel.position.y + 50 + moon.frame.height/2 )
        
        addChild(moon)
        moon.run(SKAction.scale(to: 0.6, duration: 0.5))
        
        let moonGlow = SKSpriteNode(imageNamed: "moon-glow")
        moonGlow.zPosition = moon.zPosition + 10
        
        moon.addChild(moonGlow)
        moon.glow = moonGlow

        moonGlow.alpha = 0.0

        moonGlow.run(SKAction.repeatForever(
            SKAction.sequence([
            SKAction.group([
                SKAction.fadeOut(withDuration: 1.3),
                SKAction.scale(to: 3, duration: 1.3)
                ]),
                SKAction.group([
                    SKAction.fadeIn(withDuration: 0.0),
                    SKAction.scale(to: 0.0, duration: 0.0)
                    ])
                ])
            ))
        
        self.planet = planet
        self.reachLabel = reachLabel
        self.moon = moon
    }
    
    func initTutorial () {
        
        let myTutorial = Tutorial(texture: nil, color: UIColor.clear, size: CGSize(width: 10, height: frame.height * 0.05))
        
        myTutorial.position = CGPoint(x: frame.midX,
                                      y: myTutorial.frame.height + 50)
        addChild(myTutorial)
        
        tutorial = myTutorial
    }

    // MARK: - CoreMotion
    func setupCoreMotion() {

        let queue = OperationQueue()
        
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates(to: queue, withHandler: { (data: CMDeviceMotion?, error: Error?) in
                
                if let gravity = data?.gravity {
                    var rotation = atan2( gravity.x, gravity.y)
                    rotation = rotation > 0 ?
                        max(rotation, .pi * 0.75) :
                        min(rotation, -.pi * 0.75)

                    self.applyRotation(CGFloat(rotation - .pi))
                }
            })
        }
    }

    func applyRotation(_ rotation: CGFloat){

        rocket.zRotation = rotation
    }

    // MARK: - Touches
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */

        guard let currentTouch = touches.first, gameOver == false else { return }

        if inSplashScreen {

            inSplashScreen = false
            isUserInteractionEnabled = false
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

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let currentTouch = touches.first, gameOver == false else { return }

        changeSpeedTo( calculateSpeedWith(currentTouch))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if #available(iOS 9.0, *) {
            if forceTouchEnable {
                
                changeSpeedTo(minSpeedRocket)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        if #available(iOS 9.0, *) {
            if forceTouchEnable {
                
                changeSpeedTo(minSpeedRocket)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */

        currentDistance += CGFloat(currentTime - lastFrameTime ) * speedGlobal

        updateMovimentObjects(currentTime - lastFrameTime)

        if gameOver == false {
            rocket.moveY(currentTime - lastFrameTime, size: frame.size)
        }

        super.update(currentTime)

        checkAddOtherMeteor()

        tutorial?.updateLayersPosition(speedGlobal/maxSpeedRocket)

        checkPositionOfRocket()
    }

    fileprivate func checkAddOtherMeteor() {

        if meteorShower && currentDistance - distanceOfLastMeteor > distanceBetweenMeteor {
            addMeteorToView()
        }
    }

    fileprivate func updateMovimentObjects(_ deltaTime: TimeInterval) {

        objectsInMoviments = objectsInMoviments.filter { (layer, speedX, speedY) -> Bool in
            self.moveSpriteX(layer, deltaTime: deltaTime, speed: speedX)
            self.moveSprite(layer, deltaTime: deltaTime, speed: speedY)

            if layer.frame.maxY < self.frame.minY {

                layer.removeFromParent()
                return false
            }
            return true
        }
    }

    fileprivate func checkPositionOfRocket(){

        if inHome && rocket.position.y > frame.midY {
            rocket.physicsBody?.velocity = CGVector.zero

            inHome = false
            playTheGame()
        }
    }

    fileprivate func playTheGame(){

        initTutorial()
        timeOfInitGame = lastFrameTime
        isUserInteractionEnabled = true
        if let planet = self.planet {
            objectsInMoviments.append((planet, 0.0, 20.0))
        }
        setupCoreMotion()
    }

    fileprivate func addMeteorToView(){

        distanceOfLastMeteor = currentDistance
        let meteor = Meteor()

        let ran = CGFloat(arc4random()).truncatingRemainder(dividingBy: frame.maxX)

        meteor.position = CGPoint(x: ran,
                                  y: frame.height + meteor.frame.height/2 )

        let ranSpeed = CGFloat( arc4random() % 30)

        var ranSpeedX = CGFloat ( arc4random() % 30)

        ranSpeedX *= ran > frame.midX ? -1 : 1

        addObjectToView(meteor, speedX: ranSpeedX, speedY: 30.0 + ranSpeed)
    }

    fileprivate func addObjectToView(_ object: SKSpriteNode, speedX:CGFloat, speedY: CGFloat) {

        addChild(object)
        objectsInMoviments.append((object, speedX, speedY))
    }

    // MARK: - Speed
    fileprivate func calculateSpeedWith(_ touch: UITouch) -> CGFloat {

        if #available(iOS 9.0, *) {
            if forceTouchEnable {

                return touch.force * (maxSpeedRocket - minSpeedRocket) /
                                touch.maximumPossibleForce
            }
        }
        
        let location = touch.location(in: self)

        let maxYOfControl = frame.height * 0.2
        let minYOfControl = frame.height * 0.1

        return minSpeedRocket + (max(minYOfControl, min(location.y, maxYOfControl)) - minYOfControl) *
             (maxSpeedRocket - minSpeedRocket) / (maxYOfControl - minYOfControl)
    }

    fileprivate func changeSpeedTo(_ speed: CGFloat) {

        rocket.setSpeedRocket(speed)
        setSpeedParallax(speed)
    }
}

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {

        if gameOver == false &&
            (contact.bodyA.categoryBitMask == ObjectsBitMask.rocket.rawValue &&
            contact.bodyB.categoryBitMask == ObjectsBitMask.meteor.rawValue) {

            if let meteor = contact.bodyB.node as? Meteor {

                meteor.crash()
                rocket.removeLife()
            }

            if rocket.lifes <= 0 {
                gameOver = true
                gameOverView()

            }
        }
    }
}

extension GameScene {

    func startGame() {
        guard let planet = planet else { return }

        inHome = true

        setSpeedParallax(3.0)

        rocket.position = CGPoint(x: frame.midX, y: frame.height * -0.1)
        let scale = 0.1 * frame.height / rocket.frame.height
        rocket.setScale(scale)
        rocket.smoke.particleAlphaSpeed = 0.3
        rocket.zPosition = planet.zPosition + 2
        rocket.smoke.zPosition = rocket.zPosition - 1

        addChild(rocket)
        rocket.zPosition = planet.zPosition + 1
        rocket.physicsBody?.applyImpulse(CGVector(dx: 0.0,
                                                dy: frame.height * 0.03))

        moon?.glow?.removeAllActions()
        moon?.glow?.setScale(0.5)
        moon?.glow?.alpha = 1.0
        
        moon?.glow?.run(SKAction.sequence([
            SKAction.scale(to: 3, duration: 1.5),
            SKAction.scale(to: 0.0, duration: 0.0)
            ]))
        
        moon?.run(SKAction.fadeOut(withDuration: 1.3))
        
        reachLabel?.run(SKAction.fadeOut(withDuration: 1.3))
        planet.run(SKAction.move(to: CGPoint(x: planet.position.x, y: planet.frame.height * -0.15), duration: 3.0), completion: {

            self.setSpeedParallax(0.2)
            self.rocket.smoke.particleAlphaSpeed = -2.0

            if let body = self.rocket.physicsBody {
                body.applyImpulse(CGVector(dx: 0.0, dy: body.velocity.dy * -0.06))
            }
        }) 
    }
}

extension GameScene: GameSceneDelegate {

    func restartGameButton(_ menu: GameoverScreen) {
        restartGame()
    }
}

