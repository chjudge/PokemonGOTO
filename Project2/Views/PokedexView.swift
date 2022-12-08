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
    @State var pokemonIndex: Int = -1
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        mainContent
    }
    
    var mainContent: some View {
        GeometryReader { geo in
            
            Image("pokedex_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.top)
            
//            VStack {
                
                VStack {
                    ZStack {
                        // Background box
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.primary)
                            .shadow(radius: 10)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                            .colorInvert()
                        
                        // Pokemond details
                        if pokemonIndex >= 0 && VM.filteredPokemon.count > pokemonIndex{
                            PokemonDetailView(pokemon: VM.filteredPokemon[pokemonIndex], dimensions: 150, fromPokedex: true)
                        } else {
                            Text("Select a Pokemon")
                        }
                    }
                    .frame(height: geo.size.height/3)
                    
                    ScrollView {
                        LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                            ForEach(VM.filteredPokemon, id: \.id) { pokemon in
                                Button {
                                    if let id = pokemon.id {
                                        pokemonIndex = id - 1
                                    } else { /* Do nothing */ }
                                } label: {
                                    PokemonView(pokemon: pokemon, dimensions: 120, showName: true, seen: PCViewModel.shared.pokemon.contains(where: { $0.id == pokemon.id }))
                                }
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: VM.filteredPokemon)
                    }
//                    .onre
                    .searchable(text: $VM.searchText)
                    .frame(height: geo.size.height/1.5)
                }
//            }
        }
    }
}

struct NewPokedexView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            PokedexView().preferredColorScheme($0)
        }
    }
}
