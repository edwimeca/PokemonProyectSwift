//
//  ViewController.swift
//  who is that pokemon
//

import UIKit
import Kingfisher

class PokemonViewController: UIViewController {

    @IBOutlet weak var lblBestScore: UILabel!
    @IBOutlet var btnsAnswers: [UIButton]!
    @IBOutlet weak var lblResultResponse: UILabel!
    @IBOutlet weak var imgPokemon: UIImageView!
    @IBOutlet weak var lblScore: UILabel!
    
    lazy var pokemonManager = PokemonManager()
    lazy var imageManager = ImageManager()
    lazy var game = GameModel()
    
    var random4Pokemons: [PokemonModel] = [] {  //inicialmete se declaro la variable de tipo array, luego se le agrego la funcionalidad
        //el did set ejecuta una funcio cinado el random pokemon es llenado
        didSet{
            setButtonTitles()
        }
    }
    var correctAnswer: String = ""
    var correctAnswerImage: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonManager.delegate = self
        imageManager.delegate = self
              
        createButtons()
        pokemonManager.fetchPokemon()
        lblResultResponse.text = ""
        lblBestScore.text = "Best Score : \(game.mayorScore)"
        
    }
    
    @IBAction func pressedButton(_ sender: UIButton) {
        let userAnswer = sender.title(for: .normal)!
        
        if game.checkAnswer(userAnswer, correctAnswer) {
            lblResultResponse.text = "Yes, It is a \(userAnswer.capitalized)"
            lblScore.text = "Actual Score : \(game.score)"
            lblBestScore.text = "Best Score : \(game.mayorScore)"
            
            sender.layer.borderColor = UIColor.black.cgColor  //UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 2
            
            updateImage()
            Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false){ timer in
                self.pokemonManager.fetchPokemon()
                self.lblResultResponse.text = " "
                sender.layer.borderWidth = 0
            }
        }  else {
            /*lblResultResponse.text = "Nooo, es un pokemon \(correctAnswer.capitalized)"
            sender.layer.borderColor = UIColor.systemRed.cgColor
            sender.layer.borderWidth = 2
            print ("Respuesta incorrecta")
            updateImage()
            lblScore.text = "Puntaje : \(game.score)"
            
            Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false){ timer in
                self.pokemonManager.fetchPokemon()
                self.lblResultResponse.text = " "
                sender.layer.borderWidth = 0
                
            }*/
            self.performSegue(withIdentifier: "goToResults", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Nos aseguramos que estamo enviando la informacion a la ventana que es
        if segue.identifier == "goToResults" {
            let destination = segue.destination as! ResultsViewController
            destination.pokemonName = correctAnswer
            destination.pokemonImageURL = correctAnswerImage
            destination.textButton = "Continue playing"
            
            if game.lifes != 0{
                destination.textScore = "You lost. your score is \(game.score)"                
                destination.messageGame = "OOPS! YOU LOST (\(game.lifes) lives left"
                
            }else{
                destination.messageGame = "GAME OVER"
                destination.mayorScore = game.mayorScore
                destination.textScore = "You lost. your score was \(game.score)"
                destination.textButton = "Start Again"
                resetGame()
            }
            
            self.pokemonManager.fetchPokemon()
        }
      
    }
    //Actualizamos la imagen con colores
    func updateImage (){
        let url = URL(string: correctAnswerImage)
        imgPokemon.kf.setImage(with: url)
    }
    func resetGame (){
        game.setScore(score: 0)
        game.setLifes(lifes: 3)
        lblScore.text = "Score: \(game.score)"
        self.lblResultResponse.text = " "
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
    
    func setButtonTitles(){
        for (index, button) in  btnsAnswers.enumerated() {
            DispatchQueue.main.async { [self] in
                button.setTitle(random4Pokemons[safe: index]?.name.capitalized, for:.normal)
            }
        }
    }
}

extension PokemonViewController: PokemonManagerDelegate {
    
    func didUpdatePokemon(pokemons: [PokemonModel]) {
        random4Pokemons = pokemons.choose(4)
        
        let index = Int.random(in: 0...3)
        let imageData = random4Pokemons[index].imageURL
        correctAnswer = random4Pokemons[index].name
        print ("Correct answer " + correctAnswer)
        
        imageManager.fetchImage(url: imageData)
        for pkm in random4Pokemons{
            print(pkm.name)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension PokemonViewController: ImageManagerDelegate {
    func didUpdateImage(image: ImageModel) {
        correctAnswerImage = image.imageURL
        DispatchQueue.main.async { [self] in
            //Usamos la dependencia para traer la imagen y le configuramos el collor a negro.. consultar documentacion https://github.com/onevcat/Kingfisher
            
            let url = URL(string: correctAnswerImage)
            let effec = ColorControlsProcessor(brightness: -1, contrast: 1, saturation: 1, inputEV: 0)
            imgPokemon.kf.setImage(
                with: url,
                options: [
                    .processor(effec)
                ]
            )
        }
    }
    
    func didFailWithErrorImage(error: Error) {
        print(error)
    }
}

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension Collection {
    func choose(_ n: Int) -> Array<Element> {
        Array(shuffled().prefix(n))
    }
}
