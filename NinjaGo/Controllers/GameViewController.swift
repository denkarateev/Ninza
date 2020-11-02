//
//  GameViewController.swift
//  NinjaGo
//
//  Created by Денис Каратеев on 09.10.2020.
//
import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
class GameViewController: UIViewController, GADInterstitialDelegate {
    var interstitial: GADInterstitial?

    override func viewDidLoad() {
        // реклама
        super.viewDidLoad()
        interstitial = createInterstitial()
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.presentInterstitial), name: NSNotification.Name(rawValue: "presentInterstitial"), object: nil)
        if UseIntestital {
           self.createInterstitial()
        }
        
       
        let scene = GameScene(size: CGSize(width: 2048.0, height: 1536.0))
        scene.scaleMode = .aspectFill
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
    }
   
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func createInterstitial() -> GADInterstitial {
        
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
      }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createInterstitial()
    }
    @objc func presentInterstitial() {
        
        
        if ((self.interstitial?.isReady)! && UseIntestital) {
            self.interstitial?.present(fromRootViewController: self)
        } else {
            print("ad error")
        }
    }
    
   
   

     
}
