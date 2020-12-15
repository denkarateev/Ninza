//
//  GameScene.swift
//  NinjaGo
//
//  Created by Денис Каратеев on 09.10.2020.
//

import SpriteKit
import GameplayKit
import UIKit
import GoogleMobileAds
class GameScene: SKScene {
    
   
    //MARK: - Properties
   
    var groundNode = Ground()
    var playerNode = Player()
    var cloud = Cloud()
    var hud = HUD()
    var moveSpeed: CGFloat = 8.0
    var wallTimer: Timer?
    var cloudTimer: Timer?
    var numScore = 0
    var adCount2: Int = 0
    var valueTime2: CGFloat = 2.5
    var valueTime1: CGFloat = 1.5
    var playRect: CGRect {
        let ratio: CGFloat
        switch UIScreen.main.nativeBounds.height {
        case 2688, 1792, 2436:
            ratio = 2.16
        default:
            ratio = 16/9
        }
        let playableHeight = size.width / ratio
        let playableMargin = (size.height - playableHeight) / 2.0
        return CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
    }
    var gameState: GameState = .initial {
        didSet {
            hud.setupGameState(from: oldValue, to: gameState)

        }
        
    }
    
    //MARK: - Systems
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hex: 0xB3E5FC)
        if gameState == .initial {
            setupNodes()
            setupPhysics()
            gameState = .start
           
            
            
        }
        
        //        let shape = SKShapeNode(rect: playRect)
        //        shape.lineWidth = 4.0
        //        shape.strokeColor = . red
        //        addChild(shape)
       adCount2 = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        if node.name == HUDSettings.tapToStart {
            gameState = .play
            
            isPaused = false
            setupTimer()
        } else if node.name == HUDSettings.gameOver {
            
            let scene = GameScene(size: size)
            scene.scaleMode = scaleMode
            view?.presentScene(scene, transition: .fade(with: .red, duration: 0.5))
            
            
        } else {
            playerNode.setupMoveUpDown()
        }
        
    }
    override func update(_ currentTime: TimeInterval) {
        if gameState != .play {
            isPaused = true
            return
        }
        groundNode.moveGround(self)
        moveWall()
        cloud.moveCloud(self)
        
    }
}
//MARK: - Configuration
extension GameScene {
    func setupNodes() {
        groundNode.setupGround(self)
        playerNode.setupPlayer(groundNode, scene: self)
        spawnWalls()
        cloud.setupClouds()
        setupHUD()
        // setupTimer()
        
    }
    // начать отсюда
    func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    func setupTimer() {
        if numScore % 5 == 0 {
            self.valueTime1 /= 2.0
            self.valueTime2 /= 2.0
            //                    print(valueTime1)
            //                    print(valueTime2)
          //  setupTimer()
        }

        var wallRandom = CGFloat.random(min: valueTime1, max: valueTime2)
        //  var wallRandom = CGFloat.random2(max: 8.0)
        //  run(.repeatForever(.sequence([.wait(forDuration: <#T##TimeInterval#>)])))
        run(.repeatForever(.sequence([.wait(forDuration: 5.0), .run { wallRandom -= 1.0}])))
        //   print(wallRandom)
        wallTimer = Timer.scheduledTimer(timeInterval: TimeInterval(wallRandom), target: self, selector: #selector(spawnWalls), userInfo: nil, repeats: true)
        let cloudRandom = CGFloat.random(min: 5.5, max: 10.5)
        cloudTimer = Timer.scheduledTimer(timeInterval: TimeInterval(cloudRandom), target: self, selector: #selector(spawnClouds), userInfo: nil, repeats: true)
    }
    @objc func spawnWalls() {
        let scale: CGFloat
        if Int(arc4random_uniform(UInt32(2))) == 0 {
            scale = -1.0
        } else {
            scale = 1.0
        }
        let wall = SKSpriteNode(imageNamed: "block2").copy() as! SKSpriteNode
        let value: CGFloat = wall.frame.height + groundNode.frame.height
        let wallPosY = frame.height/2.0 + (value/2.0 * scale)
        wall.position = CGPoint(x: size.width + wall.frame.width, y: wallPosY)
        wall.name = "Block"
        wall.zPosition = 2.0
        
        
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody!.isDynamic = false
        wall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        addChild(wall)
        wall.run(.sequence([.wait(forDuration: 8.0), .removeFromParent()]))
        // Score
        let score = SKSpriteNode(imageNamed: "gold")

        score.name = "Score"
        score.zPosition = 5.0
        let scorePosY = frame.height/2.0 + (value/2.0 * (-scale))
        score.position = CGPoint(x: wall.position.x + score.frame.width + 100, y: scorePosY  )
        score.physicsBody = SKPhysicsBody(rectangleOf: score.size)
        score.physicsBody!.isDynamic = false
        score.physicsBody!.categoryBitMask = PhysicsCategory.Score
        addChild(score)
    }
    func moveWall(){
        enumerateChildNodes(withName: "Block") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= self.moveSpeed
        }
        enumerateChildNodes(withName: "Score") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= self.moveSpeed
        }
    }
    @objc func spawnClouds() {
        let index = Int(arc4random_uniform(UInt32(cloud.clouds.count - 1)))
        let cloud = self.cloud.clouds[index].copy() as! Cloud
        let randomY = CGFloat.random(min: -cloud.frame.height, max: cloud.frame.height*2.0)
        cloud.position = CGPoint(x: frame.width + cloud.frame.width, y: randomY)
        addChild(cloud)
        cloud.run(.sequence([.wait(forDuration: 15.0), .removeFromParent()]))
    }
    func setupHUD() {
        
        addChild(hud)
        hud.setupScoreLbl(numScore)
        hud.setupHighScoreLbl(ScoreGenerator.sharedInstance.getHighscore())
    }
    
    func gameOver() {
        // реклама
       
        
        if UseIntestital  && (adCount4 % ADMOB_RATE == 0) {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentInterstitial"), object: nil)

        }


        playerNode.removeFromParent()
        wallTimer?.invalidate()
        cloudTimer?.invalidate()
        gameState = .dead
        isPaused = true
        let highscore = ScoreGenerator.sharedInstance.getHighscore()
        if numScore > highscore {
            ScoreGenerator.sharedInstance.setHighscore(numScore)
        }
       
        print(adCount4)



    }
    
    }

//MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
        case PhysicsCategory.Wall:
            gameOver()
        case PhysicsCategory.Score:
            if let node = other.node {
                numScore += 1
                
                hud.scoreLabel.text = "Очки: \(numScore)"
                if numScore % 5 == 0 {
                    moveSpeed += 2.0
                    self.valueTime1 /= 2.0
                    self.valueTime2 /= 2.0
                    //                    print(valueTime1)
                    //                    print(valueTime2)
                  //  setupTimer()
                }
                node.removeFromParent()
            }
            
        default: break
        }
       
    }
}
