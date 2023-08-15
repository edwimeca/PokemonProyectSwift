//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit

class PokemonViewController: UIViewController {

    @IBOutlet var btnsAnswers: [UIButton]!
    @IBOutlet weak var lblResultResponse: UILabel!
    @IBOutlet weak var imgPokemon: UIImageView!
    @IBOutlet weak var lblScore: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButtons ()
        
    }
    
    @IBAction func pressedButton(_ sender: UIButton) {
        print(sender.title(for: .normal)!)
    }
    
    
    
    func createButtons (){
        for btn in btnsAnswers {
            btn.layer.shadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            btn.layer.shadowOpacity = 1.0
            btn.layer.shadowRadius = 0
            btn.layer.masksToBounds = false
            btn.layer.cornerRadius = 10.0
        }
    }
}
