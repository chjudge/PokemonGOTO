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
    var caught: Timestamp
    
    enum CodingKeys: CodingKey {
        case name
        case caught
    }
}

struct FirestoreEvent: Identifiable, Codable {
    var id: String = UUID().uuidString
    
    var title: String
    var sender: String
    var location: GeoPoint
    var seconds: Int
    var start: Timestamp
    var end: Timestamp
    var pokemon_id: Int
    
    enum CodingKeys: CodingKey {
        case title, sender, location, seconds, start, end, pokemon_id
    }
}

