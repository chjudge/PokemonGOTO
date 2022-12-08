//
//  WorldView.swift
//  Project2
//
//  Created by Heston Suorsa on 12/6/22.
//

import SwiftUI

struct WorldView: View {
    
    @ObservedObject var MVM = MapViewModel.shared
    @State var happy: Bool = false
    @State var sad: Bool = false
    
    var details: some View {
        Image(systemName: "car")
    }
    
    var body: some View {
            MapView()
                .edgesIgnoringSafeArea(.top)
//                .alert(isPresented: $MVM.popupNotification) {
//
//                }
        }
}

struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        WorldView()
    }
}
