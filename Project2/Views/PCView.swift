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
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 150))]
    @ObservedObject var PKMManager = PokemonManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("XP: \(PCVM.userStepCount)")
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(PCVM.firestore.firestoreModels, id: \.id) { pkm in
                        NavigationLink(destination: PCDetailView(id: pkm.pokemonID)) {
                            if let pokemon = PKMManager.allPokemon.first(where: { $0.pokemon.id == pkm.pokemonID }){
                                PokemonView(pokemon: pokemon.pokemon, dimensions: 150, showName: true, showID: true)
                            }
                        }
                    }
                }
                .onReceive(PCVM.firestore.$firestoreModels){ pokemon in
                    PCVM.pokemon.removeAll()
                    for pkm in pokemon{
                        Task{
                            if let pk = await PKMManager.fetchPokemon(id: pkm.pokemonID){
                                PCVM.pokemon.append(pk)
                            }
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
