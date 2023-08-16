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
    
    lazy var pokemonManager = PokemonManager()
    
    var random4Pokemons: [PokemonModel] = []
    var correctAnswer: String = ""
    var correctAnswerImage: String = ""
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.delegate = self
        
        createButtons ()
        
        pokemonManager.fetchPokemon()
        
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

extension PokemonViewController: pokemonManagerDelegate{
    func didUpdatePokemon(pokemons: [PokemonModel]) {
        random4Pokemons = (pokemons.choose(4))
        let index = Int.random(in: 0...3)
        let imageData = random4Pokemons[index].imageURL
        correctAnswer = random4Pokemons[index].name
        
        //imageManager.fetchImage(url: imageData)
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//Metodos para crear 4 ramdoms de los pokemones
extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index:Index)-> Iterator.Element?{
        return (startIndex <= index && index < endIndex) ? self [index] : nil
    }
}

extension Collection {
    func choose(_ n: Int)-> Array<Element>{
        Array(shuffled().prefix(n))
    }
}
