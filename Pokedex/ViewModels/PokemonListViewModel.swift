//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Dylan on 17/02/2025.
//

import Foundation
import CoreData

class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    
    @Published var showSheet = false
    @Published var pokemonToShow: Pokemon? = nil
    
    @Published var searchQuery = ""
    
    var filteredPokemons: [Pokemon] {
        var pokemons: [Pokemon] = pokemons
        
        if !searchQuery.isEmpty {
            pokemons = pokemons
                .filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
        
        return pokemons.sorted { $0.id < $1.id }
    }
    
    private let pokemonRepository = PokemonRepository()
    
    private let limit = 20
    private var currentPage = 0
    
    func showPokemonSheet(pokemon: Pokemon) {
        pokemonToShow = pokemon
        showSheet = true
    }
    
    func loadPokemons() async {
        do {
            let pokemons = try await pokemonRepository.getPokemons(limit: limit, page: currentPage)
            
            await MainActor.run {
                self.pokemons += pokemons
                self.currentPage += 1
            }
        }catch {
            print("Une erreur est survenue: \(error)")
            dump(error)
        }
    }
    
    func toggleFav(pokemon: Pokemon){
        
    }
}
