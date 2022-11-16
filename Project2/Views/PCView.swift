//
//  PCView.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import SwiftUI
import PokemonAPI


struct PCView: View {
    
    @ObservedObject var vm = PCViewModel()
    
    var body: some View {
        
        NavigationView {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(vm.pokemon, id: \.self) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)
                                ) {
                                    PokemonView(pokemon: pokemon)
                                }
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: vm.count)
                        .navigationTitle("PC")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .searchable(text: $vm.searchText)
                }
                .environmentObject(vm)
        
    }
}

struct PCView_Previews: PreviewProvider {
    static var previews: some View {
        PCView()
    }
}
