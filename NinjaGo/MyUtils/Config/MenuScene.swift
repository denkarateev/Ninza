//
//  MenuScene.swift
//  NinjaGo
//
//  Created by Денис Каратеев on 25.01.2021.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(red: 100, green: 100, blue: 100, alpha: 1)
        let label = SKLabelNode(text: "Start")
        label.name = "label"
        label.position = CGPoint(x: 10, y: 10)
        label.text = "Start"
        label.fontColor = .black
        self.addChild(label)
      
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!.location(in: self)
        let node = self.atPoint(touch)
        if node.name == "label" {
        let transition = SKTransition.crossFade(withDuration: 1)
            let gameScene = GameScene(size: CGSize(width: 2048.0, height: 1536.0))
        gameScene.scaleMode = .aspectFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
}
