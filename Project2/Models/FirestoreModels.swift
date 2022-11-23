//
//  FirestoreModels.swift
//  Project2
//
//  Created by Clayton Judge on 11/21/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreUser: Identifiable, Codable {
    var id: String = UUID().uuidString

    var name: String
    var pokemon: DocumentReference?
    
    enum CodingKeys: CodingKey {
        case name
        case pokemon
    }
}

struct FirestorePokemon: Identifiable, Codable {
    var id: String = UUID().uuidString

    var name: String
    var pokemonID: Int
    var caught: Timestamp
    
    enum CodingKeys: CodingKey {
        case name
        case pokemonID
        case caught
    }
}

