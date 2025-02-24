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
