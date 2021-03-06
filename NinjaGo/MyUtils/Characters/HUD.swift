//
//  HUD.swift
//  NinjaGo
//
//  Created by Денис Каратеев on 10.10.2020.
//

import SpriteKit
import UIKit
enum HUDSettings {
    static let score = "Score"
    static let highscore = "Highscore"
    static let tapToStart = "Tap To Start"
    static let gameOver = "Game Over"
}
class HUD: SKNode {
    var scoreLabel: SKLabelNode!
    var highscoreLbl: SKLabelNode!
  //  var adCount6: Int = adCount4
    override init() {
        super.init()
        adCount4 += 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addHeart() {
        var array = [SKSpriteNode]()
        
        guard let scene = scene as? GameScene else { return }
        let iconSettings = SKSpriteNode(texture: SKTexture(image: UIImage(named: "heart")!), size: CGSize(width: 50, height: 50))
        let pos = CGPoint(x: 60, y: scene.playRect.maxY - 120.0)
        array = [iconSettings]
        iconSettings.position = pos
        addChild(iconSettings)
    }
    
    func addLabel(_ name: String, text: String, fontSize: CGFloat, pos: CGPoint) {
        let label = SKLabelNode()
        
        
        label.fontName = fontNamed
        
        label.name = name
        label.text = text
        label.fontSize = fontSize
        label.position = pos
        label.zPosition = 50.0
        addChild(label)
        
    }
    func setupScoreLbl(_ score: Int) {
        addHeart()
        guard let scene = scene as? GameScene else { return }
        let pos = CGPoint(x: 30.0, y: scene.playRect.maxY - 30.0)
        addLabel(HUDSettings.score, text: "Score: \(score)", fontSize: 70.0, pos: pos)
        scoreLabel = childNode(withName: HUDSettings.score) as? SKLabelNode
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
    }
    func setupHighScoreLbl(_ highscore: Int) {
        guard let scene = scene as? GameScene else { return }
        let pos = CGPoint(x: scene.playRect.maxX - 30.0, y: scene.playRect.maxY - 30.0)
        addLabel(HUDSettings.highscore, text: "HighScore: \(highscore)", fontSize: 70.0, pos: pos)
        highscoreLbl = childNode(withName: HUDSettings.highscore) as? SKLabelNode
        highscoreLbl.horizontalAlignmentMode = .right
        highscoreLbl.verticalAlignmentMode = .top
    }
    func addLbl(fontSize: CGFloat, name: String, text: String) {
        guard let scene = scene as? GameScene else { return }
        let pos = CGPoint(x: scene.playRect.width/2.0, y: scene.playRect.height/2.0 + 400)
        
        addLabel(name, text: text, fontSize: fontSize, pos: pos)
   
    }
    func setupGameState(from: GameState, to: GameState) {
        clearUI(gameState: from)
        updateUI(gameState: to)
    }
    func updateUI(gameState: GameState) {
        switch gameState {
        case .start:
            addLbl(fontSize: 150.0, name: HUDSettings.tapToStart, text: HUDSettings.tapToStart)
        case .dead:
            
            addLbl(fontSize: 200.0, name: HUDSettings.gameOver, text: HUDSettings.gameOver)
        default:
            break
        }
    }
    func clearUI(gameState: GameState) {
        switch gameState {
        case .start:
            childNode(withName: HUDSettings.tapToStart)?.removeFromParent()
        case .dead:
            childNode(withName: HUDSettings.gameOver)?.removeFromParent()
        default:
            break
        }
    }
    
}
