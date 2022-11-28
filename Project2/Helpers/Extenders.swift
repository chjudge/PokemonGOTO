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

extension Bundle {
    func LoadJson<T: Decodable> (resource: String) -> T? {
        // 1. get the path to the json file with the app bundle
        let pathString = Bundle.main.path(forResource: resource, ofType: "json")
        
        if let path = pathString {
            // 2. create a URL Object
            let url = URL(fileURLWithPath: path)
            
            do {
                // 3. create a Data object with the URL file
                let data = try Data(contentsOf: url)
                // 4. create a JSON decoder
                let json_decoder = JSONDecoder()
                // 5. extract the models from the json file
                return try json_decoder.decode(T.self, from: data)
                
            } catch {
                print(error)
            }
        }
        return nil
    }
}
