//
//  NewPokedexView.swift
//  Project2
//
//  Created by Clayton Judge on 11/15/22.
//

import SwiftUI
import PokemonAPI

struct PokedexView: View {
    @ObservedObject var VM = PokedexViewModel.shared
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        mainContent
    }
    
    var mainContent: some View {
        NavigationView{
            VStack {
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(VM.filteredPokemon, id: \.id) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemon: pokemon, fromPokedex: true)) {
                                PokemonView(pokemon: pokemon)
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: VM.filteredPokemon)
                    .navigationTitle("PokemonUI")
                    .navigationBarTitleDisplayMode(.inline)
                }.task {
//                    if VM.allPokemon.count < 151{
//                        await VM.loadPokemon()
//                    }
                }
                .searchable(text: $VM.searchText)
            }
        }
    }
}

struct NewPokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
