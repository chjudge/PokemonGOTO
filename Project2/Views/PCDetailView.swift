//
//  PCDetailView.swift
//  Project2
//
//  Created by Clayton Judge on 12/8/22.
//

import SwiftUI

struct PCDetailView: View {
    let pokemonOBJ: PokemonObject
    let FSPokemon: FirestorePokemon
    
    var body: some View {
        VStack{
            PokemonView(pokemon: pokemonOBJ.pokemon, dimensions: 150)
            Text("info")
        }
    }
}
