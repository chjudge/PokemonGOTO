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
    var team: [PKMPokemon]
    
    static let shared = {
        let instance = TeamViewModel()
        return instance
    }()
    
    init() {
        team = [PKMPokemon]()
        populateTeam()
    }
    
    func populateTeam() {
        // TODO: Get real team from Firestore
//        for _ in [1..<6] {
//
//        }
    }
    
}
