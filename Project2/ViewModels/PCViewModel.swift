//
//  PCViewModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/21/22.
//

import Combine
import FirebaseFirestore
import SwiftUI
import PokemonAPI

class PCViewModel: ObservableObject {
    @Published var pokemon = [PKMPokemon]()
    
    var pokemonAPI = PokemonAPI()
    
    let firestore = FirestoreManager<FirestorePokemon>(collection: "pokemon")
    
    static let shared = {
        let instance = PCViewModel()
        return instance
    }()
}
