//
//  NewPokemonView.swift
//  Project2
//
//  Created by Clayton Judge on 11/15/22.
//

import SwiftUI
import PokemonAPI

struct NewPokemonView: View {
    let pokemon: PKMPokemon
    let dimensions: Double = 120
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string:pokemon.sprites?.frontDefault ?? "")) { image in
                if let image = image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                }
            } placeholder: {
                ProgressView()
                    .frame(width: dimensions, height: dimensions)
                    
            }
            .background(.thinMaterial)
            .clipShape(Circle())

            Text("\(pokemon.name!.capitalized)")
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .padding(.bottom, 20)

        }
    }
}

