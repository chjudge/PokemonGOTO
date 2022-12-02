//
//  ContentView.swift
//  Project2
//
//  Created by Clayton Judge on 11/13/22.
//

import SwiftUI
import PokemonAPI

struct ContentView: View {
    
    @State var tabIndex = 0
    
    var body: some View {
        
        ZStack {
            
            TabView(selection: $tabIndex) {
                
                PCView().tabItem {
                    Image(systemName: "car")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("PC")
                }
                .tag(0)
                
                MapView().tabItem {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Map")
                }
                .tag(1)
                
                PokedexView().tabItem {
                    Image(systemName: "info")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Pokedex")
                }
                .tag(2)
//                NewMapView().tabItem {
//                    Image(systemName: "globe")
//                        .imageScale(.large)
//                        .foregroundColor(.accentColor)
//                    Text("Map")
//                }
//                .tag(3)
                
                TeamView().tabItem {
                    Image(systemName: "person.3")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Pokemon")
                }
                .tag(4)
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
