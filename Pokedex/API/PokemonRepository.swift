//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by Dylan on 24/02/2025.
//

import Foundation

class PokemonRepository {
    let pokemonService = PokemonService()
    
    func getPokemons(limit: Int, page: Int, search: String? = nil) async throws -> [Pokemon] {
        let offset = limit * page
        let list = try await pokemonService.fetchPokemonList(limit: limit, offset: offset, search: search)
        
        return try await withThrowingTaskGroup(of: Pokemon?.self) { group in
            for result in list.results {
                group.addTask { try await self.getPokemon(name: result.name) }
            }
            
            var results: [Pokemon] = []
            
            for try await pokemon in group {
                if let pokemon = pokemon {
                    results.append(pokemon)
                }
            }
            
            return results
        }
    }
    
    func getPokemon(name: String) async throws -> Pokemon {
        let pokemon = try await pokemonService.fetchPokemon(name: name)
        let stats = Dictionary(uniqueKeysWithValues: pokemon.stats.map { ($0.stat.name, $0.baseStat) })
        
        return Pokemon(
            id: pokemon.id,
            name: pokemon.name,
            image: URL(string: pokemon.sprites.other.official.frontDefault)!,
            
            types: pokemon.types.map(\.type.name),
            
            hp: stats[PokemonStatsType.hp] ?? 0,
            
            stats: stats
        )
    }
}
