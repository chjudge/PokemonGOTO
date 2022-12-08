//
//  AuthManager.swift
//  Project2
//
//  Created by Clayton Judge on 11/22/22.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

class UserManager: ObservableObject {
    private var db = Firestore.firestore()
    var uid: String?
    var user: FirestoreUser?
    
    static let shared = {
        let instance = UserManager()
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
                        PCViewModel.shared.healthKitManager.setUpHealthRequest()
                    } catch {
                        print("error loading user from firestore")
                    }
                } else {
                    print("adding user to users collection")
                    let start_day: Date = .now
                    self.user = FirestoreUser(steps: 0, start_day: Timestamp(date: start_day))
                    
                    PCViewModel.shared.healthKitManager.setUpHealthRequest()
                    do {
                        try userDoc.setData(from: self.user)
                    } catch  {
                        print("error setting user or pokemon")
                    }
                }
            }
            let userpkm = "users/\(uid)/pokemon"
            print("creating query \(userpkm)")
            PCViewModel.shared.firestore.subscribe(to: PCViewModel.shared.firestore.query(collection: userpkm))
            
            let userteam = "users/\(uid)/team"
            print("creating query \(userteam)")
            TeamViewModel.shared.firestore.subscribe(to: TeamViewModel.shared.firestore.query(collection: userteam))
        }
    }
    
    func addXP(steps: Int){
        user?.steps -=  steps
        updateUser()
    }
    
    func removeXP(steps: Int){
        user?.steps +=  steps
        updateUser()
    }
    
    func updateUser(){
        if let uid = uid{
            do{
                try db.collection("users").document(uid).setData(from: self.user)
            } catch  {
                print("error setting user or pokemon")
            }
        } else {
            print("error no uid")
        }
    }
}
