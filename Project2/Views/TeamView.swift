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
    
    @State private var showSheet: Bool = false
    @State private var teamIndex: Int = 0
    @State private var didFail = false
    
    private let adaptiveColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        //        NavigationView {
        LazyVGrid(columns: adaptiveColumns, spacing: 10) {
            ForEach(0..<6, id: \.self){ index in
                Button {
                    teamIndex = index
                    showSheet.toggle()
                } label: {
                    if let pokemon = TVM.team[index] {
                        PokemonView(pokemon: pokemon, dimensions: 120, showName: true)
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
        }.onReceive(TVM.firestore.$firestoreModels){ documents in
            for doc in documents{
                Task{
                    if let pkm = await PKMManager.fetchPokemon(ref: doc.pokemon){
                        TVM.team[doc.index] = pkm
                    }
                }
            }
        }
        .sheet(isPresented: $showSheet){
            ScrollView {Button{
                PKMManager.removeFromTeam(index: teamIndex)
                showSheet.toggle()
            }label: {
                Text("Remove")
            }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 10) {
                    
                    ForEach(PCViewModel.shared.pokemon, id: \.id){ pkm in
                        if (!TVM.team.contains(pkm)) {
                            Button{
                                PKMManager.addToTeam(pokemonID: pkm.id!, index: teamIndex, didFail: $didFail)
                                showSheet.toggle()
                            } label: {
                                PokemonView(pokemon: pkm, dimensions: 120, showName: true)
                            }
                        }
                    }
                }
            }.padding()
        }
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
