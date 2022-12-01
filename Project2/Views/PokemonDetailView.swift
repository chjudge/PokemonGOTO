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
    @State var types: [PKMType] = []
    
    @State private var didFail = false
    
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
                        .task {
                            print("loading types")
                            types = await PKMManager.fetchType(types: pokemon.types!)
                        }
//                    ForEach(moves, id: \.id){move in
//                        if let name = move.name{
//                            Text(name)
//                        }
//                    }
                    // ADD pokemon to PC button
                    
                    Spacer()
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
                    } else {
                        Button {
                            PKMManager.addToTeam(pokemonID: pokemon.id!, index: 0, didFail: $didFail)
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add to team")
                            }
                        }.alert(
                            "This pokemon is already on your team",
                            isPresented: $didFail
                        ) { }
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
        
    }
}

