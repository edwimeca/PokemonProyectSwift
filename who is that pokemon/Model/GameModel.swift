//
//  GameModel.swift
//  who is that pokemon
//
//  Created by Edwin Mejia on 14/08/23.
//

import Foundation

class GameModel {
    var score = 0
    var lifes = 3
    var mayorScore = 0
    
    func checkAnswer (_ userAnswer:String, _ correctAnswer:String)->Bool{
        if userAnswer.lowercased() == correctAnswer.lowercased(){
            score += 1
            return true
        } else {
            lifes -= 1
            return false
        }
        if lifes == 0 && score >= mayorScore {
            mayorScore = score
            print("mayor score \(mayorScore)")
            
        }
    }
    
    func getScore ()-> Int{
        return score
    }
    
   func setScore (score: Int) {
        self.score = score
   }
   func setLifes (lifes: Int) {
         self.lifes = lifes
   }
}
