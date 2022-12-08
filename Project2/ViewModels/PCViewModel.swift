//
//  PCViewModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/21/22.
//

import PokemonAPI
import HealthKit

class PCViewModel: ObservableObject {
    let healthKitManager = HealthKitManager()
    
    @Published var pokemon = [PKMPokemon]()
    @Published var userStepCount = 0
    
    let firestore = FirestoreManager<FirestorePokemon>(collection: "pokemon")
    
    static let shared = {
        let instance = PCViewModel()
        return instance
    }()
}
