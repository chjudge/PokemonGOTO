//
//  TeamSelectionView.swift
//  Project2
//
//  Created by Heston Suorsa on 12/1/22.
//

import SwiftUI

struct TeamSelectionView: View {
    @ObservedObject var PCVM = PCViewModel.shared
    @ObservedObject var PKMManager = PokemonManager.shared
    @ObservedObject var TVM = TeamViewModel.shared
    @State private var didFail = false
    let index: Int
    
    var body: some View {
        VStack {
            List(PCVM.pokemon, id: \.id) { pkm in
                Button {
                    if (!TVM.team.contains(pkm)) {
                        PKMManager.addToTeam(pokemonID: pkm.id!, index: index, didFail: $didFail)
                    }
                    // TODO: return to team view somehow
                    //TeamView()
                } label: {
                    PokemonView(pokemon: pkm, dimensions: 120)
                }
            }//.onReceive(PCVM.firestore.$firestoreModels){ pokemon in
//                PCVM.pokemon.removeAll()
//                for pkm in pokemon{
//                    Task{
//                        if let pk = await PKMManager.fetchPokemon(id: pkm.pokemonID){
//                            PCVM.pokemon.append(pk)
//                        }
//                    }
//                }
//            }
        }
        .navigationBarTitle("My PC")
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            if let uid = AuthManager.shared.uid {
//                let path = "users/\(uid)/pokemon"
//                print("creating query \(path)")
//                let query = PCVM.firestore.query(collection: path)
//                PCVM.firestore.subscribe(to: query)
//            }
//        }
//        .onDisappear {
//            PCVM.firestore.unsubscribe()
//        }
    }
}

struct TeamSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSelectionView(index: 0)
    }
}
