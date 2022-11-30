//
//  PokemonManager.swift
//  Project2
//
//  Created by Clayton Judge on 11/30/22.
//

import Foundation
import PokemonAPI
import FirebaseFirestore

class PokemonManager: ObservableObject {
    let pokemonAPI = PokemonAPI()
    private var db = Firestore.firestore()
    
    static let shared = {
        let instance = PokemonManager()
        return instance
    }()
    
    @Published var allPokemon: [PKMPokemon] = [PKMPokemon]()
    
    func loadPokemon(paginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 151)) async {
        let start = allPokemon.count
        
        do {
            let pagedObject = try await pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState)
            if let results = pagedObject.results as? [PKMNamedAPIResource]{
                await withThrowingTaskGroup(of: Void.self){ group in
                    for r in results.suffix(from: start){
                        group.addTask{
                            let pkm = try await self.pokemonAPI.pokemonService.fetchPokemon(r.name!)
                            DispatchQueue.main.async{ self.allPokemon.append(pkm) }
                        }
                    }
                }
            }
        } catch {
            print("Error loading pokedex: \(error.localizedDescription)")
        }
    }
    
    func fetchPokemon(id: Int) async -> PKMPokemon?{
        if let pkm = allPokemon.first(where: { $0.id == id } ){
            return pkm
        }
        do {
            let pkm = try await pokemonAPI.pokemonService.fetchPokemon(id)
            return pkm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
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
        do{
            for type in types{
                let t = try await pokemonAPI.pokemonService.fetchType(type.type!.name!)
                out.append(t)
            }
        } catch{
            print(error.localizedDescription)
        }
        return out
    }
    
    func add(pokemon: PKMPokemon) {
        let collection = db.collection(AuthManager.shared.pkmPath ?? "pokemon")
        
        if let name = pokemon.name, let id = pokemon.id {
            //check if pokemon already caught
            collection.document("\(id)").getDocument{ (document, error) in
                if let document = document, document.exists {
                    print("Error: Pokemon already in PC")
                    return
                }
            }
            
            let pkm = FirestorePokemon(pokemonID: id, name: name, caught: .init())
            
            do {
                try collection.document("\(id)").setData(from: pkm)
            } catch {
                print("Error adding pokemon to PC \(error.localizedDescription)")
            }
        }
    }
}
