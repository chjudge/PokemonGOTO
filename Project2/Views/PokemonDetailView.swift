//
//  PokemonView.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import Foundation
import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var vm: PokedexViewModel
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            PokemonView(pokemon: pokemon)
            
            VStack(spacing: 10) {
                Text("**ID**: \(vm.pokemonDetails?.id ?? 0)")
                Text("**Weight**: \(vm.formatHW(value: vm.pokemonDetails?.weight ?? 0)) KG")
                Text("**Height**: \(vm.formatHW(value: vm.pokemonDetails?.height ?? 0)) M")
                
            }
            .padding()
        }
        .onAppear {
            vm.getDetails(pokemon: pokemon)
        }
    }
}
//
struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemon: Pokemon.samplePokemon)
            .environmentObject(PokedexViewModel())
    }
}
