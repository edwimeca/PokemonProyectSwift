//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Edwin Mejia on 14/08/23.
//

import Foundation

protocol pokemonManagerDelegate {
    func didUpdatePokemon(pokemons: [PokemonModel])
    func didFailWithError(error: Error)
}

struct PokemonManager {
    
    let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=998&offset=0)"
    //let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=4&offset=\(Int.random(in: 0...994))"
    
       
    var delegate: pokemonManagerDelegate?
    
    func fetchPokemon (){
        performRequest(with: pokemonURL)
    }
    
    private func performRequest(with urlString: String) {
            // 1. Create/get URL
            if let url = URL(string: urlString) {
                // 2. Create the URL session
                let session = URLSession(configuration: .default)
                // 3. Give the session a task
                let task = session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        self.delegate?.didFailWithError(error: error)
                    }
                    
                    if let safeData = data {
                        if let pokemon = self.parseJSON(pokemonData: safeData) {
                            self.delegate?.didUpdatePokemon(pokemons: pokemon)
                        }
                    }
                }
                // 4. Start the task
                task.resume()
            }
        }
             
    private func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(PokemonData.self, from: pokemonData)
            let pokemon = decodeData.results?.compactMap({
                if let name = $0.name, let imageURL = $0.url {
                    return PokemonModel(name: name, imageURL: imageURL)
                }
                return nil
            })
            return pokemon
        } catch {
            return nil
        }
    }
    
    
}

