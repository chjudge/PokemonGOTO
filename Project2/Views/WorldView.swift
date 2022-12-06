//
//  WorldView.swift
//  Project2
//
//  Created by Heston Suorsa on 12/6/22.
//

import SwiftUI

struct WorldView: View {
    
    @ObservedObject var MVM = MapViewModel.shared
    
    var body: some View {
        MapView()
//            .alert(
//                "Event pokemon added to your collection",
//                isPresented: // TODO: Bool to represent timer finished
//            ) { }
    }
}

struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        WorldView()
    }
}
