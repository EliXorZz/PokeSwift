//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Dylan on 17/02/2025.
//

import Foundation
import CoreData

class PokemonListViewModel: ObservableObject {
    
    
    
    @Published var pokemonItems: [PokemonList.Item] = []
    @Published var pokemons: [String:Pokemon] = [:]
    @Published var pokemonFavorite: [Int] = []
    
    private let sizePage = 20
    private var offsetPage = 0
    
    func loadPokemons() async {
        do {
            let pokemonList = try await PokemonService.fetchPokemonList(limit: sizePage, offset: offsetPage)
            
            await MainActor.run {
                self.offsetPage += self.sizePage
                self.pokemonItems += pokemonList.results
            }
        }catch {
            print("Une erreur est survenue: \(error)")
        }
    }
    
    func loadPokemon(name: String) async {
        do {
            let newPokemon = try await PokemonService.fetchPokemon(name: name)
            
            await MainActor.run {
                self.pokemons[name] = newPokemon
            }
        }catch {
            print("Une erreur est survenue: \(error)")
        }
    }
}
