//
//  ContentView.swift
//  Project2
//
//  Created by Clayton Judge on 11/13/22.
//

import SwiftUI
import PokemonAPI

struct ContentView: View {
    
    @State var tabIndex = 1
    
    var body: some View {
        TabView(selection: $tabIndex) {
            
            PCView().tabItem {
                Image(systemName: "car")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("PC")
            }
            
            MapView().tabItem {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Map")
            }.tag(1)
            
            PokedexView().tabItem {
                Image(systemName: "info")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Pokedex")
            }
            
            NewPokedexView().tabItem{
                Image(systemName: "person")
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
