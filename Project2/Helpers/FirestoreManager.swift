//
//  FirestoreManager.swift
//  Project2
//
//  Created by Clayton Judge on 11/28/22.
//

import Combine
import FirebaseFirestore
import SwiftUI

class FirestoreManager<Model: Codable>: ObservableObject {
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let baseQuery: Query
    
    @Published var firestoreModels = [Model]()
    
    
    init(collection: String = "pokemon", limit: Int = 50) {
        baseQuery = db.collection(collection).limit(to: limit)
    }
    
    func subscribe(to query: Query){
        if listener == nil{
            listener = query.addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                guard let self = self else { return }
                
                self.firestoreModels = documents.compactMap { document in
                    do {
//                        print(document.documentID)
                        let doc = try document.data(as: Model.self)
//                        print("Doc: \(doc)")
                        return doc
                    } catch {
                        print(error.localizedDescription)
                        return nil
                    }
                }
            }
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
    
    func query(query: Query? = nil, collection: String? = nil) -> Query {
        if let query = query{
            return query
        } else if let collection = collection{
            return db.collection(collection).limit(to: 50)
        } else {
            return baseQuery
        }
    }
}
