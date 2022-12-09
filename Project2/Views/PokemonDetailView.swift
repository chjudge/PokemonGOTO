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
    var fromPokedex: Bool = false
    let seen: Bool?
    
    let PKMManager = PokemonManager.shared
    
//    @State var types: [PKMType] = []
    
    @State private var didFail = false
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                PokemonView(pokemon: pokemon, dimensions: dimensions, showName: true, showID: true, seen: seen ?? true)
            
                VStack(spacing: 10) {
                    
                    if seen ?? true {
                        Text("**Weight**: \(String(format: "%.2f", Double(pokemon.weight ?? 0) / 10)) KG")
                        Text("**Height**: \(String(format: "%.2f", Double(pokemon.height ?? 0) / 10)) M")
                        if let types = PKMManager.allPokemon.first{ $0.pokemon.id == pokemon.id }!.types {
                            Text("**Type**: \(types.compactMap{$0.name!}.reduce("", {String("\($0) \($1)")}))")
                        }
                    } else {
                        Text("**Weight**: ??? KG")
                        Text("**Height**: ??? M")
                        Text("**Type**: ???")
                    }

                    // ADD pokemon to PC button
                    
//                    Spacer()
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
