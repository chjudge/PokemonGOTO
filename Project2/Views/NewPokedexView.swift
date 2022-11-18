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
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        mainContent
    }
    
    var mainContent: some View {
        NavigationView{
            VStack {
                if let error = VM.error {
                    Text("An error occurred: \(error.localizedDescription)")
                }
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(VM.filteredPokemon, id: \.id) { pokemon in
                            NavigationLink(destination: NewPokemonDetailView(pokemon: pokemon)) {
                                NewPokemonView(pokemon: pokemon)
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: VM.filteredPokemon)
                    .navigationTitle("PokemonUI")
                    .navigationBarTitleDisplayMode(.inline)
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
