//
//  NewPokemonDetailView.swift
//  Project2
//
//  Created by Clayton Judge on 11/16/22.
//

import SwiftUI
import PokemonAPI

struct PokemonDetailView: View {
    let pokemon: PKMPokemon
    let dimensions: Double
    
    let PKMManager = PokemonManager.shared
    
    var fromPokedex: Bool = false
//    @State var types: [PKMType] = []
    
    @State private var didFail = false
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                PokemonView(pokemon: pokemon, dimensions: dimensions, showName: true, showID: true)
            
                VStack(spacing: 10) {
                    
                    //Text("**ID**: \(pokemon.id ?? 0)")
                    Text("**Weight**: \(String(format: "%.2f", Double(pokemon.weight ?? 0) / 10)) KG")
                    Text("**Height**: \(String(format: "%.2f", Double(pokemon.height ?? 0) / 10)) M")
                    Text("**Type**: \((PKMManager.allPokemon.first{ $0.pokemon.id == pokemon.id }!.types.compactMap{$0.name!}.reduce("", {String("\($0) \($1)")})))")

                    // ADD pokemon to PC button
                    
                    if fromPokedex {
                        Button {
                            PKMManager.add(pokemon: pokemon, didFail: $didFail)
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add to PC")
                            }
                        }.alert(
                            "This pokemon is already in your PC",
                            isPresented: $didFail
                        ) { }
                    }
                }
                .padding()
            }
        }
    }
}
