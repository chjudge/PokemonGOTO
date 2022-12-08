//
//  NewPokemonView.swift
//  Project2
//
//  Created by Clayton Judge on 11/15/22.
//

import SwiftUI
import PokemonAPI

struct PokemonView: View {
    let pokemon: PKMPokemon
    let dimensions: Double
    let showName: Bool
    let showID: Bool
    
    init(pokemon: PKMPokemon, dimensions: Double, showName: Bool = false, showID: Bool = false) {
        self.pokemon = pokemon
        self.dimensions = dimensions
        self.showName = showName
        self.showID = showID
    }
    
//    init(pokemon: PKMPokemon, dimensions: Double, showName: Bool) {
//        self.pokemon = pokemon
//        self.dimensions = dimensions
//        self.showName = showName
//    }
    
    var body: some View {
        VStack {
            
            if showID {
                Text("No. \(pokemon.id!)")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .foregroundColor(.primary)
            }
            
            AsyncImage(url: URL(string:pokemon.sprites?.frontDefault ?? "")) { image in
                if let image = image {
                    image
                        .renderingMode(.template)
//                        .colorMultiply(.black)
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .foregroundColor(.black)
                }
            } placeholder: {
                ProgressView()
                    .frame(width: dimensions, height: dimensions)
                    
            }
            .background(.thinMaterial)
            .clipShape(Circle())
//            .colorMultiply(.black)

            if showName{
                Text("\(pokemon.name!.capitalized)")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .padding(.bottom, 20)
                    .foregroundColor(.primary)
            }
        }
    }
}

