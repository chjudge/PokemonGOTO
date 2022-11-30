//
//  TeamView.swift
//  Project2
//
//  Created by Heston Suorsa on 11/30/22.
//

import SwiftUI

struct TeamView: View {
    
    @ObservedObject var TVM = TeamViewModel.shared
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        
        LazyVGrid(columns: adaptiveColumns, spacing: 10) {
            ForEach(TVM.team, id: \.id) { pokemon in
                PokemonView(pokemon: pokemon, dimensions: 120)
            }
        }
        
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
