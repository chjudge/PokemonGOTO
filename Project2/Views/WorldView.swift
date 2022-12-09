//
//  WorldView.swift
//  Project2
//
//  Created by Heston Suorsa on 12/6/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct WorldView: View {
    
    @ObservedObject var MVM = MapViewModel.shared
    @State var showEvent = false
    
    var body: some View {
        ZStack {
            MapView(showEvent: $showEvent)
                .sheet(isPresented: $showEvent) {
                    MapSheetView(pointOfInterest: MVM.pointOfInterest, parentView: self)
                }
                .edgesIgnoringSafeArea(.top)
            //            .alert(
            //                "Event pokemon added to your collection",
            //                isPresented: // TODO: Bool to represent timer finished
            //            ) { }
        }
    }
}

struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        WorldView()
    }
}
