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
    let seen: Bool
    
    init(pokemon: PKMPokemon, dimensions: Double, showName: Bool = false, showID: Bool = false, seen: Bool = true) {
        self.pokemon = pokemon
        self.dimensions = dimensions
        self.showName = showName
        self.showID = showID
        self.seen = seen
    }
    
    var body: some View {
        VStack {
            
            if showID {
                if seen {
                    Text(String(format: "No. %03d", pokemon.id!))
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .foregroundColor(.primary)
                } else {
                    Text("No. ???")
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .foregroundColor(.primary)
                }
            }
            
            AsyncImage(url: URL(string:pokemon.sprites?.frontDefault ?? "")) { image in
                if let image = image {
                    if seen{
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: dimensions, height: dimensions)
                    } else {
                        image
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: dimensions, height: dimensions)
                            .foregroundColor(.black)
                    }
                }
            } placeholder: {
                ProgressView()
                    .frame(width: dimensions, height: dimensions)
                    
            }
            .background(.thinMaterial)
            .clipShape(Circle())

            if showName{
                if seen {
                    Text("\(pokemon.name!.capitalized)")
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .padding(.bottom, 20)
                        .foregroundColor(.primary)
                } else {
                    Text("????")
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .padding(.bottom, 20)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

