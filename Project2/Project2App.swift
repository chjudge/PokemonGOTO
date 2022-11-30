//
//  Project2App.swift
//  Project2
//
//  Created by Clayton Judge on 11/13/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct Project2App: App {
    init(){
        FirebaseApp.configure()
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { print("error authenticating user: \(error!)"); return }
            print(user.uid)
            if Auth.auth().currentUser != nil{
                print("setting user")
                AuthManager.shared.setUser()
            }
        }

        Task{ await PokemonManager.shared.loadPokemon() }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
