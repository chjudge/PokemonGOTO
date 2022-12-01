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
    
    private let adaptiveColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
//        Text("lol broken")
        NavigationView {
            LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                ForEach(0..<6, id: \.self){ index in
                    NavigationLink {
                        TeamSelectionView(index: index)
                    } label: {
                        if let pokemon = TVM.team[index] {
                            PokemonView(pokemon: pokemon, dimensions: 120)
                        } else {
                            VStack{
                                Circle()
                                    .background(.thinMaterial)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                Text("Empty")
                                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                                    .padding(.bottom, 20)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                
                //            ForEach(TVM.team, id: \.id) { pokemon in
                //                PokemonView(pokemon: pokemon, dimensions: 120)
                //            }
            }.onReceive(TVM.firestore.$firestoreModels){ documents in
                for doc in documents{
                    Task{
                        if let pkm = await PKMManager.fetchPokemon(ref: doc.pokemon){
                            TVM.team[doc.index] = pkm
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
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
