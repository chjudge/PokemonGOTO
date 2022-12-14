//
//  PokemonManager.swift
//  Project2
//
//  Created by Clayton Judge on 11/30/22.
//

import Foundation
import PokemonAPI
import FirebaseFirestore
import SwiftUI

struct PokemonObject {
    var pokemon: PKMPokemon
    var types: [PKMType]?
    var sprite: UIImage?
}

class PokemonManager: ObservableObject {
    let pokemonAPI = PokemonAPI()
    private var db = Firestore.firestore()
    
    static let shared = {
        let instance = PokemonManager()
        return instance
    }()
    
    @Published var allPokemon: [PokemonObject] = [PokemonObject]()
    
    var betterPKM = [PokemonObject]()
    
    func loadPokemon(paginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 151)) async {
        let start = allPokemon.count
        
        do {
            let pagedObject = try await pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState)
            if let results = pagedObject.results as? [PKMNamedAPIResource]{
                await withThrowingTaskGroup(of: Void.self){ group in
                    for r in results.suffix(from: start){
                        group.addTask{ [self] in
                            let pkm = try await pokemonAPI.pokemonService.fetchPokemon(r.name!)
                            let pokemonOBJ = PokemonObject(pokemon: pkm)
                            DispatchQueue.main.async{ self.allPokemon.append(pokemonOBJ) }
                        }
                    }
                }
            }
            await withThrowingTaskGroup(of: Void.self){ group in
                for pokemon in self.allPokemon{
                    group.addTask{ [self] in
                        let pkm = pokemon.pokemon
                        
                        let types = await fetchType(types: pkm.types!)

                        var image: UIImage? = nil

                        if let url = URL(string: pkm.sprites?.frontDefault ?? ""){
                            let imageData = try Data(contentsOf: url)
                            image = UIImage(data: imageData)
                        }
                        
                        let pokemonOBJ = PokemonObject(pokemon: pkm, types: types, sprite: image)
                        DispatchQueue.main.async{ self.betterPKM.append(pokemonOBJ) }
                    }
                }
            }
            DispatchQueue.main.async{ self.allPokemon = self.betterPKM }
            
        } catch {
            print("Error loading pokedex: \(error.localizedDescription)")
        }
    }
    
    func fetchPokemon(ref: DocumentReference) async -> PKMPokemon? {
        do {
            let doc = try await ref.getDocument()
            if doc.exists{
                let FSPKM = try doc.data(as: FirestorePokemon.self)
                return await fetchPokemon(id: FSPKM.pokemonID)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchPokemon(id: Int) async -> PKMPokemon?{
        if let pkm = allPokemon.first(where: { $0.pokemon.id == id } ){
            return pkm.pokemon
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
    
    func add(pokemon: PKMPokemon, didFail: Binding<Bool>) {
        let collection = db.collection("users/\(UserManager.shared.uid!)/pokemon")
        
        if let name = pokemon.name, let id = pokemon.id {
            //check if pokemon already caught
            collection.document("\(id)").getDocument{ (document, error) in
                if let document = document, document.exists {
                    print("Error: Pokemon already in PC")
                    didFail.wrappedValue = true
                } else {
                    let pkm = FirestorePokemon(pokemonID: id, name: name, caught: .init(), level: 1, hp: 30, maxHP: 30, xp: 0)
                    
                    do {
                        try collection.document("\(id)").setData(from: pkm)
                    } catch {
                        print("Error adding pokemon to PC \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func addReward(pokemon: PKMPokemon, level: Int) {
        let collection = db.collection("users/\(UserManager.shared.uid!)/pokemon")
        
        if let name = pokemon.name, let id = pokemon.id {
            //check if pokemon already caught
            collection.document("\(id)").getDocument{ (document, error) in
                if let document = document, document.exists {
                    print("Error: Pokemon already in PC")
                } else {
                    let pkm = FirestorePokemon(pokemonID: id, name: name, caught: .init(), level: 1, hp: 30, maxHP: 30, xp: 0)
                    
                    do {
                        try collection.document("\(id)").setData(from: pkm)
                    } catch {
                        print("Error adding pokemon to PC \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func addToTeam(pokemonID: Int, index: Int, didFail: Binding<Bool>) {
        let pokemon = db.collection("users/\(UserManager.shared.uid!)/pokemon")
        
        let team = db.collection("users/\(UserManager.shared.uid!)/team")
        
        do {
            let ref = pokemon.document("\(pokemonID)")
            print(ref.path)
            try team.document("\(index)").setData(from: FirestoreTeam(pokemon: ref, index: index))
        } catch {
            print("Error adding pokemon to team \(error.localizedDescription)")
            didFail.wrappedValue = true
        }
    }
    
    func removeFromTeam(index: Int) {
        db.collection("users/\(UserManager.shared.uid!)/team").document("\(index)").delete()
    }
    
    func newRandomPokemon(pokemon: FirestorePokemon){
        let collection = db.collection("map_pokemon")
        
        do {
            try collection.document("\(pokemon.pokemonID)").setData(from: pokemon)
        } catch {
            print("Error adding pokemon to PC \(error.localizedDescription)")
        }
        
    }
    
    func removeWildPokemon(id: Int){
        db.collection("map_pokemon").document("\(id)").delete()
        print("removed \(id)")
    }
    
    func addXP(id: Int, xp: Int){
        let pokemon = db.collection("users/\(UserManager.shared.uid!)/pokemon").document("\(id)")
        
        pokemon.getDocument{ (document, error) in
            if let document = document, document.exists {
                do {
                    var data = try document.data(as: FirestorePokemon.self)
                    data.xp += xp
                    try pokemon.setData(from: data)
                    
                } catch {
                    print("error with the xp")
                }
                
            } else {
                print("Error adding xp to pokemon in PC")
                if let err = error{
                    print(err.localizedDescription)
                }
            }
        }
        
        UserManager.shared.removeXP(steps: xp)
        
        let startDay = Calendar.current.startOfDay(for: UserManager.shared.user!.start_day.dateValue())
        
        PCViewModel.shared.healthKitManager.readStepCount(startDay: startDay) { step in
            print("in the closure \(step)")
            if step != 0.0 {
                DispatchQueue.main.async {
                    //calculate how much they have remaining
                    PCViewModel.shared.userStepCount = Int(step) - UserManager.shared.user!.steps
                }
            }
        }
    }
}
