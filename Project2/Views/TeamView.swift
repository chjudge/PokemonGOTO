//
//  TeamView.swift
//  Project2
//
//  Created by Heston Suorsa on 11/30/22.
//

import SwiftUI

struct TeamView: View {
    
    @ObservedObject var TVM = TeamViewModel.shared
    @ObservedObject var PKMManager = PokemonManager.shared
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        
//        Text("lol broken")
        
        LazyVGrid(columns: adaptiveColumns, spacing: 10) {
            ForEach(TVM.team, id: \.id) { pokemon in
                PokemonView(pokemon: pokemon, dimensions: 120)
            }
        }.onReceive(TVM.firestore.$firestoreModels){ documents in
            TVM.team.removeAll()
            for doc in documents{
                Task{
                    if let pk = await PKMManager.fetchPokemon(ref: doc.pokemon){
                            TVM.team.append(pk)
                        }
                    }
                }
            }
        .onAppear {
            if let uid = AuthManager.shared.uid {
                let path = "users/\(uid)/team"
                print("creating query \(path)")
                let query = TVM.firestore.query(collection: path)
                TVM.firestore.subscribe(to: query)
            }
        }
        .onDisappear {
            TVM.firestore.unsubscribe()
        }
        
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
