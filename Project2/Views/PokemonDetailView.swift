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
    @State var types: [PKMType] = []
    
//    @State var moves: [PKMMove] = []
    
//    func getMoves(moveResources: [PKMPokemonMove]) async {
//        //get first 4 moves
//        for m in moveResources[..<4]{
//            if let newMove =  await VM.fetchMove(moveResource: m.move!){
//                moves.append(newMove)
//            }
//        }
//    }
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                PokemonView(pokemon: pokemon, dimensions: dimensions)
            
                VStack(spacing: 10) {
                    
                    Spacer()
                    
                    Text("**ID**: \(pokemon.id ?? 0)")
                    Text("**Weight**: \(String(format: "%.2f", Double(pokemon.weight ?? 0) / 10)) KG")
                    Text("**Height**: \(String(format: "%.2f", Double(pokemon.height ?? 0) / 10)) M")
//                    ForEach(types, id: \.id){ type in
//
//                    }
                    Text("**Type**: \(types.compactMap{$0.name!}.reduce("", {String("\($0) \($1)")}))")
//                    ForEach(moves, id: \.id){move in
//                        if let name = move.name{
//                            Text(name)
//                        }
//                    }
                    // ADD pokemon to PC button
                    
                    Spacer()
                    if fromPokedex {
                        Button {
                            VM.add(pokemon: pokemon)
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add to PC")
                            }
                        }
                    }
                }
                .padding()
//            .task {
//                if let pokemonMoves = pokemon.moves{
//                    await getMoves(moveResources: pokemonMoves)
//                }
//            }
            }
        }
        .task {
            print("loading types")
            types = await VM.fetchType(types: pokemon.types!)
        }
    }
}

