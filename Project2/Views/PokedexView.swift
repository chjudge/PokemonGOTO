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
    @State var pokemonIndex: Int = 0
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        mainContent
    }
    
    var mainContent: some View {
        //NavigationView{
        VStack {
            
            Text("Pokedex")
                .font(.largeTitle)
            
            GeometryReader { geo in
                
                VStack {
                    ZStack {
                        // Background box
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .frame(height: geo.size.height/2)
                            .shadow(radius: 10)
                            .padding(.horizontal, 10)
                        
                        // Pokemond details
                        PokemonDetailView(pokemon: VM.filteredPokemon[pokemonIndex], dimensions: 150, fromPokedex: true)
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                            ForEach(VM.filteredPokemon, id: \.id) { pokemon in
                                
                                Button {
                                    if let id = pokemon.id {
                                        pokemonIndex = id - 1
                                    } else { /* Do nothing */ }
                                } label: {
                                    PokemonView(pokemon: pokemon, dimensions: 120)
                                }
                                
                                //                            NavigationLink(destination: PokemonDetailView(pokemon: pokemon,       fromPokedex: true)) {
                                //                                PokemonView(pokemon: pokemon)
                                //                            }
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
        //} // Nav view
    }
}

struct NewPokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
