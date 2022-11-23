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
    
    let VM = PokemonViewModel.shared
    
    var fromPokedex: Bool = false
    
    @State var moves: [PKMMove] = []
    
    func getMoves(moveResources: [PKMPokemonMove]) async {
        //get first 4 moves
        for m in moveResources[..<4]{
            if let newMove =  await VM.fetchMove(moveResource: m.move!){
                moves.append(newMove)
            }
        }
    }
    
    var body: some View {
        VStack{
            PokemonView(pokemon: pokemon, dimensions: dimensions)
            
            HStack {
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("**ID**: \(pokemon.id ?? 0)")
                    Text("**Weight**: \(String(format: "%.2f", Double(pokemon.weight ?? 0) / 10)) KG")
                    Text("**Height**: \(String(format: "%.2f", Double(pokemon.height ?? 0) / 10)) M")
                    
                    ForEach(moves, id: \.id){move in
                        if let name = move.name{
                            Text(name)
                        }
                    }
                    
                    
                }
                .padding()
                //            .task {
                //                if let pokemonMoves = pokemon.moves{
                //                    await getMoves(moveResources: pokemonMoves)
                //                }
                //            }
                
                Spacer()
                
                // ADD pokemon to PC button
                if fromPokedex {
                    Button {
                        print("adding \(pokemon.name!) to my PC")
                        VM.add(pokemon: pokemon)
                    } label: {
                        VStack {
                            Image(systemName: "plus")
                            Text("Add to PC")
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

