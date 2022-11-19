//
//  PokemonViewModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/17/22.
//

import Foundation
import PokemonAPI

class PokemonViewModel: ObservableObject{
    let pokemonAPI = PokemonAPI()
    
    func fetchMove(moveResource: PKMNamedAPIResource<PKMMove>) async -> PKMMove?{
        do{
            return try await pokemonAPI.moveService.fetchMove(moveResource.name!)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
//    func fetchMove(moveResource: String) -> PKMMove?{
//        print("Trying to fetch move")
//        print("move: \(moveResource)")
//        var outMove: PKMMove? = nil
//        pokemonAPI.moveService.fetchMove(moveResource){ result in
//            switch result{
//            case.success(let move):
//                print(move.name ?? "BROKE")
//                outMove = move
//            case .failure(let error):
//                print("Error fetching move: \(error)")
//            }
//        }
//        print("Done")
//        return outMove
//    }
}
