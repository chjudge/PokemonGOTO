//
//  PCView.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import SwiftUI
import PokemonAPI
import FirebaseAuth

struct PCView: View {
    
    @ObservedObject var PCVM = PCViewModel.shared
    @ObservedObject var PKMManager = PokemonManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("XP: \(PCVM.userStepCount)")
                List(PCVM.firestore.firestoreModels, id: \.id) { pkm in
                    NavigationLink(destination: PCDetailView(id: pkm.pokemonID)) {
                        if let pokemon = PKMManager.allPokemon.first(where: { $0.pokemon.id == pkm.pokemonID }){
                            PokemonView(pokemon: pokemon.pokemon, dimensions: 120, showName: true, showID: true)
                        }
                    }
                }
            }
            .navigationBarTitle("My PC")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PCView_Previews: PreviewProvider {
    static var previews: some View {
        PCView()
    }
}
