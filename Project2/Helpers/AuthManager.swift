//
//  AuthManager.swift
//  Project2
//
//  Created by Clayton Judge on 11/22/22.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

class AuthManager: ObservableObject {
    private var db = Firestore.firestore()
    var uid: String?
    var user: FirestoreUser?
    
    static let shared = {
        let instance = AuthManager()
        return instance
    }()
    
    func setUser(){
        if let user = Auth.auth().currentUser{
            uid = user.uid
        }
        if let uid = uid{
            let userDoc = db.collection("users").document(uid)
            userDoc.getDocument{ (document, error) in
                if let document = document, document.exists {
                    do{
                        print("getting user")
                        self.user = try document.data(as: FirestoreUser.self)
                    } catch {
                        print("error loading user from firestore")
                    }
                } else {
                    print("adding user to users collection")
                    let user = FirestoreUser(steps: 0)
                    do {
                        try userDoc.setData(from: user)
                    } catch  {
                        print("error setting user or pokemon")
                    }
                }
            }
            var userpkm = "users/\(uid)/pokemon"
            print("creating query \(userpkm)")
            PCViewModel.shared.firestore.subscribe(to: PCViewModel.shared.firestore.query(collection: userpkm))
            
            var event = "event"
            print("creating query \(event)")
            MapViewModel.shared.firestore.subscribe(to: MapViewModel.shared.firestore.query(collection: event))
            
            var userteam = "users/\(uid)/team"
            print("creating query \(userteam)")
            TeamViewModel.shared.firestore.subscribe(to: TeamViewModel.shared.firestore.query(collection: userteam))
        }
    }
}
