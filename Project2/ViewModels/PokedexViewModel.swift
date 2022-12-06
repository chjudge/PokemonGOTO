//
//  NewPokedexModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/15/22.
//

import Foundation
import PokemonAPI

class PokedexViewModel: ObservableObject{
    let pokemonAPI = PokemonAPI()
    var PKMManager = PokemonManager.shared
    
    static let shared = {
        let instance = PokedexViewModel()
        return instance
    }()
    
    @Published var searchText = ""
    
    var filteredPokemon: [PKMPokemon] {
        return PKMManager.allPokemon.map{ $0.pokemon }.sorted{ $0.id! < $1.id! }
//        let list = searchText.isEmpty ? PKMManager.allPokemon.map{ $0.pokemon } : PKMManager.allPokemon.filter({ $0.name!.contains(searchText.lowercased()) })
//        return list.sorted {$0.id! < $1.id!}
    }
}
