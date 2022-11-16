//
//  PokemonModel.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import Foundation

struct PokemonPage: Decodable {
    let count: Int
    let next: String
    let results: [Pokemon]
}

struct Pokemon: Decodable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String
    
    static var samplePokemon = Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
}

struct DetailPokemon: Decodable {
    let id: Int
    let height: Int
    let weight: Int
}
