//
//  FirestoreManager.swift
//  Project2
//
//  Created by Clayton Judge on 11/28/22.
//

import Combine
import FirebaseFirestore
import SwiftUI

class FirestoreManager<Model: Decodable>: ObservableObject {
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let baseQuery: Query
    
    @Published var firestoreModels = [Model]()
    
    
    init(collection: String, limit: Int = 50) {
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
                        let doc = try document.data(as: Model.self)
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
    
    func query() -> Query {
        var query = baseQuery

        return query
    }
}
