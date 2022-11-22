//
//  PCView.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import SwiftUI
import PokemonAPI


struct PCView: View {
    
    @ObservedObject var PCVM = PCViewModel.shared
    
    var body: some View {
        NavigationView {
            VStack {
                List(PCVM.PCPokemon, id: \.id) { pkm in
                    NavigationLink(destination: PokemonDetailView(pokemon: PCVM.fetchPokemon(id: pkm.pokemonID))) {
                        PokemonView(pokemon: PCVM.fetchPokemon(id: pkm.pokemonID))
                    }
                }
            }
            .navigationBarTitle("My PC")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let query = PCVM.query()
                PCVM.subscribe(to: query)
            }
            .onDisappear {
              PCVM.unsubscribe()
            }
        }
        
        
    }
}

struct PCView_Previews: PreviewProvider {
    static var previews: some View {
        PCView()
    }
}
