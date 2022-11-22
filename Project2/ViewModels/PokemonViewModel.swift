//
//  PokemonViewModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/17/22.
//

import Foundation
import PokemonAPI

class PokemonViewModel: ObservableObject{
    let pokemonAPI = PokemonAPI()
    
    static let shared = {
        let instance = PokemonViewModel()
        return instance
    }()
    
    func fetchMove(moveResource: PKMNamedAPIResource<PKMMove>) async -> PKMMove?{
        do{
            return try await pokemonAPI.moveService.fetchMove(moveResource.name!)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
