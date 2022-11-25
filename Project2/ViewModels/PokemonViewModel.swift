//
//  PokemonViewModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/17/22.
//

import FirebaseFirestore
import Combine
import PokemonAPI

class PokemonViewModel: ObservableObject{
    let pokemonAPI = PokemonAPI()
    
    private var db = Firestore.firestore()
    
    static let shared = {
        let instance = PokemonViewModel()
        return instance
    }()
    
    func fetchMove(moveResource: PKMNamedAPIResource<PKMMove>) async -> PKMMove? {
        do{
            return try await pokemonAPI.moveService.fetchMove(moveResource.name!)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchType(types: [PKMPokemonType]) async -> [PKMType] {
        var out = [PKMType]()
        print(types.count)
        do{
            for type in types{
                let t = try await pokemonAPI.pokemonService.fetchType(type.type!.name!)
                print(t.name!)
                out.append(t)
            }
        } catch{
            print(error.localizedDescription)
        }
        return out
    }
    
    func add(pokemon: PKMPokemon) {
        let collection = db.collection("pokemon")
        
        if let name = pokemon.name, let id = pokemon.id{
            let pkm = FirestorePokemon(name: name, pokemonID: id, caught: .init())
            
            do {
                let doc = try collection.addDocument(from: pkm)
                print(doc.documentID)
            } catch {
                print("Error adding pokemon to PC \(error.localizedDescription)")
            }
        }
        
    }
}
