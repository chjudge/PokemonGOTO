//
//  NewPokemonDetailView.swift
//  Project2
//
//  Created by Clayton Judge on 11/16/22.
//

import SwiftUI
import PokemonAPI

struct NewPokemonDetailView: View {
    let pokemon: PKMPokemon
    
    var body: some View {
        VStack{
            NewPokemonView(pokemon: pokemon)
            
            VStack(spacing: 10) {
                Text("**ID**: \(pokemon.id ?? 0)")
                Text("**Weight**: \(String(format: "%.2f", Double(pokemon.weight ?? 0) / 10)) KG")
                Text("**Height**: \(String(format: "%.2f", Double(pokemon.height ?? 0) / 10)) M")
                
            }
            .padding()
        }
    }
}

