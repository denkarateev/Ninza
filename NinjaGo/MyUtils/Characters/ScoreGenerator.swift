//
//  ScoreGenerator.swift
//  NinjaGo
//
//  Created by Денис Каратеев on 11.10.2020.
//

import Foundation
class ScoreGenerator {
    static var count: Int = 0
    static let sharedInstance = ScoreGenerator()
    private init(){}
    static let keyHighscore = "keyHighscore"
    
    func setHighscore(_ highscore: Int) {
        UserDefaults.standard.set(highscore, forKey: ScoreGenerator.keyHighscore)
    }
    func getHighscore() -> Int {
        return  UserDefaults.standard.integer(forKey: ScoreGenerator.keyHighscore)
    }
}
