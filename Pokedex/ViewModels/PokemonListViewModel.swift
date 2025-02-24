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
    
    private let pokemonRepository = PokemonRepository()
    
    private let limit = 20
    private var currentPage = 0
    
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
}
