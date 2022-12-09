//
//  PCDetailView.swift
//  Project2
//
//  Created by Clayton Judge on 12/8/22.
//

import SwiftUI

struct PCDetailView: View {
    let id: Int
    
    let PCVM = PCViewModel.shared
    let PKMManager = PokemonManager.shared
    
    @State var PKMOBJ: PokemonObject?
    @State var FSPKM: FirestorePokemon?
    
    var body: some View {
        VStack{
            if let PKMOBJ = PKMOBJ, let FSPKM = PCVM.firestore.firestoreModels.first(where: { $0.pokemonID == id }) {
                PokemonView(pokemon: PKMOBJ.pokemon, dimensions: 150)
                Text("XP: \(FSPKM.xp)")
                Button{
                    PKMManager.addXP(id: id, xp: 300)
                } label: {
                    Text("give xp")
                }
            }
        }
        .onAppear{
            PKMOBJ = PKMManager.allPokemon.first(where: { $0.pokemon.id! == id })
            FSPKM = PCVM.firestore.firestoreModels.first(where: { $0.pokemonID == id })
        }
        .onReceive(PCVM.firestore.$firestoreModels){ pokemon in
            FSPKM = pokemon.first(where: { $0.pokemonID == id })
        }
    }
}
