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
    private var listener: ListenerRegistration?
    
    static let shared = {
        let instance = PokemonViewModel()
        return instance
    }()
    
    func fetchMove(moveResource: PKMNamedAPIResource<PKMMove>) async -> PKMMove?{
        do{
            return try await pokemonAPI.moveService.fetchMove(moveResource.name!)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
//    func add(pokemon: PKMPokemon) {
//        db.runTransaction({ (transaction, errorPointer) -> Any? in
//
//        }) { object, error in
//            if let error = error {
//                print("Transaction failed: \(error)")
//            }
//        }
//    }
    
    deinit {
      unsubscribe()
    }
    
    func unsubscribe() {
      if listener != nil {
        listener?.remove()
        listener = nil
      }
    }

//    func subscribe() {
//        if listener == nil {
//            listener = restaurant.ratingsCollection?.addSnapshotListener {
//                [weak self] querySnapshot, error in
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//
//                guard let self = self else { return }
//                self.reviews = documents.compactMap { document in
//                    do {
//                        return try document.data(as: Review.self)
//                    } catch {
//                        print(error)
//                        return nil
//                    }
//                }
//            }
//        }
//    }
}
