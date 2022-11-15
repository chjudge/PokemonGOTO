//
//  ContentView.swift
//  Project2
//
//  Created by Clayton Judge on 11/13/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            
            PCView().tabItem {
                Image("pokedex")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("PC")
            }
            
            MapView().tabItem {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Map")
            }
            
            PokedexView().tabItem {
                Image(systemName: "info")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Pokedex")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}