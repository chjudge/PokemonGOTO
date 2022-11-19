//
//  NewPokedexView.swift
//  Project2
//
//  Created by Clayton Judge on 11/15/22.
//

import SwiftUI
import PokemonAPI

struct NewPokedexView: View {
    @ObservedObject var VM = NewPokedexViewModel()
    
    
    var body: some View {
        mainContent
    }
    
    var mainContent: some View {
        NavigationView{
            VStack {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(VM.filteredPokemon, id: \.id) { pokemon in
                            NavigationLink(destination: NewPokemonDetailView(pokemon: pokemon)) {
                                NewPokemonView(pokemon: pokemon)
                            }
                        }
                    }
                    //j.animation(.easeInOut(duration: 0.3), value: VM.filteredPokemon)
                    .navigationTitle("PokemonUI")
                    .navigationBarTitleDisplayMode(.inline)
                }.task {
                    if VM.allPokemon.isEmpty{
                        await VM.loadPokemon()
                    }
                }
                .searchable(text: $VM.searchText)
            }
        }
    }
}

struct NewPokedexView_Previews: PreviewProvider {
    static var previews: some View {
        NewPokedexView()
    }
}
