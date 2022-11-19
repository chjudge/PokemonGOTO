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
    
    let VM = PokemonViewModel()
    
    @State var moves: [PKMMove] = []
    
    func getMoves(moveResources: [PKMPokemonMove]) async {
        for m in moveResources{
            print("trying to get move \(m.move!.name!)")
            if let newMove =  await VM.fetchMove(moveResource: m.move!){
                moves.append(newMove)
            }
        }
    }
    
    var body: some View {
        VStack{
            NewPokemonView(pokemon: pokemon)
            
            VStack(spacing: 10) {
                Text("**ID**: \(pokemon.id ?? 0)")
                Text("**Weight**: \(String(format: "%.2f", Double(pokemon.weight ?? 0) / 10)) KG")
                Text("**Height**: \(String(format: "%.2f", Double(pokemon.height ?? 0) / 10)) M")
                
                ForEach(moves, id: \.id){move in
                    if let name = move.name{
                        Text(name)
                    }
                }
                
//                Text("Move: \(pokemon.moves![0].move!.name!)")
                //Text("Move: \(VM.fetchMove(moveResource: pokemon.moves![0].move!)?.name ?? "error fetching ")")
                
            }
            .padding()
            .task {
                                if let pokemonMoves = pokemon.moves{
                                    print("trying to get moves")
                                    await getMoves(moveResources: pokemonMoves)
                                }
                            }
        }
    }
}

