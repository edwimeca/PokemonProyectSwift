//
//  ResultsViewController.swift
//  who is that pokemon
//
//  Created by Edwin Mejia on 23/08/23.
//

import UIKit
import Kingfisher

class ResultsViewController: UIViewController {
   
    @IBOutlet weak var btnPlayAgain: UIButton!
    @IBOutlet weak var lblMesageGame: UILabel!
    @IBOutlet weak var imgPokemon: UIImageView!
    @IBOutlet weak var lblFinalScore: UILabel!
    @IBOutlet weak var lblMessageNonPokemon: UILabel!
    
    var pokemonName = ""
    var pokemonImageURL = ""
    var textScore = ""
    var messageGame = " "
    var mayorScore = 0
    var textButton = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblFinalScore.text = textScore
        lblMessageNonPokemon.text = "No. it is a \(pokemonName.capitalized)"
        imgPokemon.kf.setImage(with: URL(string: pokemonImageURL))
        lblMesageGame.text = messageGame
        btnPlayAgain.setTitle(textButton, for: .normal)
    }
    
    @IBAction func btnPlayAgainPressed(_ sender: UIButton) {        
        self.dismiss(animated: true)
    }
    
}
    
   


