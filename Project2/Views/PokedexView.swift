//
//  PokedexView.swift
//  Project2
//
//  Created by Clayton Judge on 11/14/22.
//

import SwiftUI
import PokemonAPI

struct PokedexView: View {
    
    @ObservedObject var vm = PokedexViewModel()
    
    var body: some View {
        NavigationView {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(vm.filteredPokemon) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)
                                ) {
                                    PokemonView(pokemon: pokemon)
                                }
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: vm.filteredPokemon.count)
                        .navigationTitle("PokemonUI")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .searchable(text: $vm.searchText)
                }
                .environmentObject(vm)
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
