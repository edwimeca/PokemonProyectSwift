//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Edwin Mejia on 14/08/23.
//

import Foundation

struct PokemonManager {
    
    
    let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=898&offset=0"
    
    func performRequest(with urlString: String) {
            // 1. Create/get URL
            if let url = URL(string: urlString) {
                // 2. Create the URL session
                let session = URLSession(configuration: .default)
                // 3. Give the session a task
                let task = session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error)
                    }
                    
                    if let safeData = data {
                        if let pokemon = self.parseJSON(pokemonData: safeData) {
                            print(pokemon)
                        }
                    }
                }
                // 4. Start the task
                task.resume()
            }
        }
             
    func parseJSON(pokemonData: Data) -> [PokemonModel]? {
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

