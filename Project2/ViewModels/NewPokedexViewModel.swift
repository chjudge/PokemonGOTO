//
//  NewPokedexModel.swift
//  Project2
//
//  Created by Clayton Judge on 11/15/22.
//

import Foundation
import PokemonAPI

class NewPokedexViewModel: ObservableObject{
    let pokemonAPI = PokemonAPI()
    
    
    
    @Published var searchText = ""
    @Published var allPokemon: [PKMPokemon] = [PKMPokemon]()
    
    var filteredPokemon: [PKMPokemon] {
        let list = searchText.isEmpty ? allPokemon : allPokemon.filter({ $0.name!.contains(searchText.lowercased()) })
            return list.sorted {$0.id! < $1.id!}
        
    }
    
//    @Published var pagedObject: PKMPagedObject<PKMPokemon>?
//    @Published var pageIndex = 0
    
//    init(){
//        allPokemon = [PKMPokemon]()
//        Task{
//            await loadPokemon()
//        }
//    }
//
//    func fetchPokemon(paginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 151)) async {
//        do {
//            pagedObject = try await pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState)
//            pageIndex = pagedObject?.currentPage ?? 0
//            if let pagedObject = pagedObject,
//               let pokemonResults = pagedObject.results as? [PKMNamedAPIResource]{
//                for p in pokemonResults{
//                    let pkm = try await pokemonAPI.pokemonService.fetchPokemon(p.name!)
//                    allPokemon.append(pkm)
//                }
//            }
//        }
//        catch {
//            self.error = error
//        }
//    }
    
    func loadPokemon(paginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 151)) async {
        do {
            let pagedObject = try await pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState)
            if let results = pagedObject.results as? [PKMNamedAPIResource]{
                for r in results{
                    print(r.name!)
                    let pokemon = try await self.pokemonAPI.pokemonService.fetchPokemon(r.name!)
                    self.allPokemon.append(pokemon)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
        
//        pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState){ result in
//            switch result{
//            case .success(let pagedObject):
//                if let results = pagedObject.results as? [PKMNamedAPIResource]{
//                    for r in results{
//                        self.pokemonAPI.pokemonService.fetchPokemon(r.name!) { result in
//                            switch result{
//                            case .success(let pokemon):
//                                self.allPokemon.append(pokemon)
//                            case .failure(let error):
//                                print(error)
//                            }
//                        }
//
//                    }
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//
            
//        }
    }
    
//    func loadPokemon() async{
//        await fetchPokemon()
//        for i in 0..<151{
//            pagedObject?.results[i]
//        }
//    }
//
//    func fetchPokemon(name: String) async -> PKMPokemon {
//        do {
//            let pokemon = try await pokemonAPI.pokemonService.fetchPokemon(name)
//            return pokemon
//        } catch{
//            print(error)
//        }
//    }
    
}

