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
        
        ZStack {
            
            TabView(selection: $tabIndex) {
                
                PCView().tabItem {
                    Label("PC", systemImage: "car")
                }
                .tag(0)
                
                WorldView().tabItem {
                    Label("Map", systemImage: "globe")
                }
                .tag(1)
                
                PokedexView().tabItem {
                    Label("Pokedex", systemImage: "info")
                }
                .tag(2)
                
                TeamView().tabItem {
                    Label("Team", systemImage: "person.3")
                }
                .tag(3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ContentView().preferredColorScheme($0)
        }
    }
}
