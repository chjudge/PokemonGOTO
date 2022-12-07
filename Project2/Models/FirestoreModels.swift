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

struct FirestoreWildPokemon: Identifiable, Codable {
    var id: String = UUID().uuidString

    var pokemonID: Int
    var name: String
    var caught: Date // Timestamp
    var location: GeoPoint
    var moves: [Int]?
    var level: Int
    var hp: Int
    var maxHP: Int
    var xp: Int
    
    enum CodingKeys: CodingKey {
        case name
        case pokemonID
        case caught
        case location
        case moves
        case level
        case hp
        case maxHP
        case xp
    }
}

struct FirestoreEvent: Identifiable, Codable {
    @DocumentID var id: String? // = UUID().uuidString
    
    var title: String
    var sender: String
    var location: GeoPoint
    var radius: Float
    var seconds: Int
    var start: Date // Timestamp
    var end: Date // Timestamp
    var pokemon_id: Int
    
    enum CodingKeys: CodingKey {
        case id, title, sender, location, radius, seconds, start, end, pokemon_id
    }
}

struct FirestoreActiveEvent: Identifiable, Codable {
    @DocumentID var id: String? // = UUID().uuidString
    
    var event_id: String
    var seconds: Int
    
    enum CodingKeys: CodingKey {
        case id, event_id, seconds
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


