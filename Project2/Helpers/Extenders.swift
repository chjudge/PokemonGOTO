//
//  Extenders.swift
//  Project2
//
//  Created by Heston Suorsa on 11/17/22.
//

import Foundation
import PokemonAPI

extension PKMPokemon : Equatable{
    public static func == (lhs: PKMPokemon, rhs: PKMPokemon) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PKMPokemonMove : Equatable {
    public static func == (lhs: PKMPokemonMove, rhs: PKMPokemonMove) -> Bool {
        lhs.move?.name == rhs.move?.name
    }
}
