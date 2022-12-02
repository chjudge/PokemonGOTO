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

    var pokemon: DocumentReference?
    var team: DocumentReference?
    var steps: Int
    
    enum CodingKeys: CodingKey {
        case pokemon
        case team
        case steps
    }
}

struct FirestorePokemon: Identifiable, Codable {
    var id: String = UUID().uuidString

    var pokemonID: Int
    var name: String
    var caught: Timestamp
    var moves: [Int]?
    var level: Int
    var hp: Int
    var maxHP: Int
    var xp: Int
    
    enum CodingKeys: CodingKey {
        case name
        case pokemonID
        case caught
        case moves
        case level
        case hp
        case maxHP
        case xp
    }
}

struct FirestoreEvent: Identifiable, Codable {
    var id: String = UUID().uuidString
    
    var title: String
    var sender: String
    var location: GeoPoint
    var radius: Float
    var seconds: Int
    var start: Timestamp
    var end: Timestamp
    var pokemon_id: Int
    
    enum CodingKeys: CodingKey {
        case title, sender, location, radius, seconds, start, end, pokemon_id
    }
}

struct FirestoreTeam: Identifiable, Codable {
    var id: String = UUID().uuidString
    
    var pokemon: DocumentReference
    var index: Int
    
    enum CodingKeys: CodingKey {
        case pokemon
        case index
    }
}

