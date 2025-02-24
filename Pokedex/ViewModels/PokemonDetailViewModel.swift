//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//
import Foundation
import CoreData

class PokemonDetailViewModel: ObservableObject {
    @Published var randPokemon: Pokemon?
    @Published var showingFightView = false
    @Published var isFavorite = false
    var randPage = Int.random(in: 1...1303)

    
    private let pokemonRepository = PokemonRepository()
    
    func loadRandomPokemon() async {
        do {
            randPage = Int.random(in: 1...1303)
            let pokemons = try await pokemonRepository.getPokemons(limit: 1, page: randPage)
            randPokemon = pokemons.first!
        }catch {
            print("Une erreur est survenue: \(error)")
            dump(error)
        }
    }
}
