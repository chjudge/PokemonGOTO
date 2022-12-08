//
//  PCView.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import SwiftUI
import PokemonAPI
import FirebaseAuth

struct PCView: View {
    
    @ObservedObject var PCVM = PCViewModel.shared
    @ObservedObject var PKMManager = PokemonManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("XP: \(PCVM.userStepCount)")
                List(PCVM.pokemon, id: \.id) { pkm in
                    NavigationLink(destination: PokemonDetailView(pokemon:pkm, dimensions: 120)) {
                        PokemonView(pokemon: pkm, dimensions: 120)
                    }
                }.onReceive(PCVM.firestore.$firestoreModels){ pokemon in
                    PCVM.pokemon.removeAll()
                    for pkm in pokemon{
                        Task{
                            if let pk = await PKMManager.fetchPokemon(id: pkm.pokemonID){
                                    PCVM.pokemon.append(pk)
                                }
                            }
                        }
                    
                }
            }
            .navigationBarTitle("My PC")
            .navigationBarTitleDisplayMode(.inline)
//            .onAppear {
//                if let uid = AuthManager.shared.uid {
//                    let path = "users/\(uid)/pokemon"
//                    print("creating query \(path)")
//                    let query = PCVM.firestore.query(collection: path)
//                    PCVM.firestore.subscribe(to: query)
//                }
//            }
//            .onDisappear {
//                PCVM.firestore.unsubscribe()
//            }
        }
    }
}

struct PCView_Previews: PreviewProvider {
    static var previews: some View {
        PCView()
    }
}
