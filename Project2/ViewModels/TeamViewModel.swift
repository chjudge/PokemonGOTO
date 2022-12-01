//
//  TeamViewModel.swift
//  Project2
//
//  Created by Heston Suorsa on 11/30/22.
//

import Foundation
import PokemonAPI

class TeamViewModel: ObservableObject {
    let pokemonAPI = PokemonAPI()
    var PKMManager = PokemonManager.shared
    
    let firestore = FirestoreManager<FirestoreTeam>()
    
    @Published var team: [PKMPokemon] = [PKMPokemon]()
    
    static let shared = {
        let instance = TeamViewModel()
        return instance
    }()
}
