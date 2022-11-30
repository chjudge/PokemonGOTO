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
    var pkmPath: String?
    var user: FirestoreUser?
    
    let firestore = FirestoreManager<FirestoreUser>(collection: "users")
    
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
                        let pkm = userDoc.collection("pokemon")
                        self.pkmPath = pkm.path
                        print("pkm path: \(self.pkmPath!)")
                    } catch {
                        print("error loading user from firestore")
                    }
                } else {
                    print("adding user to users collection")
                    let user = FirestoreUser()
                    let bulb = FirestorePokemon(pokemonID: 1, name: "Bulbasaur", caught: .init())
                    do {
                        try userDoc.setData(from: user)
                        let pkm = userDoc.collection("pokemon")
                        try pkm.document("1").setData(from: bulb)
                        self.pkmPath = pkm.path
                        print("pkm path: \(self.pkmPath!)")
                    } catch  {
                        print("error setting user or pokemon")
                    }
                }
            }
        }
    }
}
