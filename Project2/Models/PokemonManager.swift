//
//  PokemonManager.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import Foundation

class PokemonManager {
    func getPokemon() -> [Pokemon] {
        let data: PokemonPage? = Bundle.main.decodeJSON("pokemon")
        if let d = data {
            let pokemon: [Pokemon] = d.results
            return pokemon
        }
        
        return [Pokemon]()
    }
    
    func getDetailedPokemon(id: Int, _ completion:@escaping (DetailPokemon) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)/", model: DetailPokemon.self) { data in
            completion(data)
            print(data)
            
        } failure: { error in
            print(error)
        }
    }
}
