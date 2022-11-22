//
//  Project2App.swift
//  Project2
//
//  Created by Clayton Judge on 11/13/22.
//

import SwiftUI
import FirebaseCore

@main
struct Project2App: App {
    init(){
        FirebaseApp.configure()
        Task{ await PokedexViewModel.shared.loadPokemon() }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
