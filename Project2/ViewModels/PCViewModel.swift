//
//  PCViewModel.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import Foundation
import PokemonAPI

class PCViewModel: ObservableObject {
    
    var pokemon: [PKMPokemon]
    let count: Int
    @Published var searchText = ""
    
    init() {
        pokemon = [PKMPokemon]()
        count = pokemon.count
        pokemon = fetchLocalPCPokemon()
    }
    
    func fetchLocalPCPokemon() -> [PKMPokemon] {
        // TODO: Loads local saved data
        return [PKMPokemon]()
    }
    
}
