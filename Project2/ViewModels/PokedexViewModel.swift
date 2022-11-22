//
//  NewPokedexModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/15/22.
//

import Foundation
import PokemonAPI

class PokedexViewModel: ObservableObject{
    let pokemonAPI = PokemonAPI()
    
    static let shared = {
        let instance = PokedexViewModel()
        return instance
    }()
    
    @Published var searchText = ""
    @Published var allPokemon: [PKMPokemon] = [PKMPokemon]()
    
    var filteredPokemon: [PKMPokemon] {
        let list = searchText.isEmpty ? allPokemon : allPokemon.filter({ $0.name!.contains(searchText.lowercased()) })
        return list.sorted {$0.id! < $1.id!}
    }
    
    func loadPokemon(paginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 151)) async {
        let start = allPokemon.count
        
        do {
            let pagedObject = try await pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState)
            if let results = pagedObject.results as? [PKMNamedAPIResource]{
                for r in results.suffix(from: start){
                    let pokemon = try await self.pokemonAPI.pokemonService.fetchPokemon(r.name!)
                    DispatchQueue.main.async {
                        self.allPokemon.append(pokemon)
                    }
                }
            }
        } catch {
            print("Error loading pokedex: \(error.localizedDescription)")
        }
    }
}
