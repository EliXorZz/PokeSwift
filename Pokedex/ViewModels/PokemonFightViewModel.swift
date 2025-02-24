//
//  PokemonFightViewModel.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//

import Foundation
import CoreData

class PokemonFightViewModel: ObservableObject {
    
    @Published var pokemon1HP: Int = 0
    @Published var pokemon2HP: Int = 0
    
    @Published var currentPokemon: Pokemon? = nil
    @Published var randomPokemon: Pokemon? = nil
    
    @Published var showingAttackAnimation = false
    @Published var currentTurn = 1
    
    @Published var finished = false
    
    private let pokemonRepository = PokemonRepository()
    
    init(pokemon : Pokemon){
        self.currentPokemon = pokemon
    }

    
    func load() async {
        do {
            let randPage = Int.random(in: 1...1303)
            let pokemons = try await pokemonRepository.getPokemons(limit: 1, page: randPage)
            self.randomPokemon = pokemons.first!
            await MainActor.run {
                self.pokemon1HP = self.currentPokemon!.hp
                self.pokemon2HP = self.randomPokemon!.hp
            }
        }catch {
            print("Une erreur est survenue: \(error)")
            dump(error)
        }
    }
}
