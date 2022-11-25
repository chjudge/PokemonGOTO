//
//  PCViewModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/21/22.
//

import Combine
import FirebaseFirestore
import SwiftUI
import PokemonAPI

class PCViewModel: ObservableObject {
    //var user: FirestoreUser
    @Published var PCPokemon = [FirestorePokemon]()
    @Published var pokemon = [PKMPokemon]()
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let baseQuery: Query = Firestore.firestore().collection("pokemon").limit(to: 50)
    
    var pokemonAPI = PokemonAPI()
    
    static let shared = {
        let instance = PCViewModel()
        return instance
    }()
    
    func fetchPokemon(id: Int) async {
        do {
            let pkm = try await pokemonAPI.pokemonService.fetchPokemon(id)
            DispatchQueue.main.async {
                self.pokemon.append(pkm)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        unsubscribe()
    }
    
    func unsubscribe() {
        if listener != nil {
          listener?.remove()
          listener = nil
        }
    }
    
    func subscribe(to query: Query){
        if listener == nil{
            listener = query.addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                guard let self = self else { return }
                
                self.PCPokemon = documents.compactMap { document in
                    do {
                        let pokemon = try document.data(as: FirestorePokemon.self)
                        if !self.pokemon.contains(where: { pkm in pkm.id ?? -1 == pokemon.pokemonID }){
                            Task{
                                await self.fetchPokemon(id: pokemon.pokemonID)
                            }
                        }
                        return pokemon
                    } catch {
                        print(error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    }
    
    func query(id: Int? = nil) -> Query {
        var query = baseQuery
        
        if let id = id {
            query = query.whereField("pokemonID", isEqualTo: id)
        }
        
        return query
    }
    
    func filter(query: Query) {
        unsubscribe()
        subscribe(to: query)
    }
}
