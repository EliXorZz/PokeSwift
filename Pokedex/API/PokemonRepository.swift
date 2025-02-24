//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by Dylan on 24/02/2025.
//

import Foundation
import CoreData


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
        
        let viewContext = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
        request.predicate = NSPredicate(format: "name == %@", name.lowercased())
        request.fetchLimit = 1
        
        do {
            if let pokemonEntity = try viewContext.fetch(request).first {
                let types = pokemonEntity.types?.allObjects as [TypeEntity]
                
                
                return Pokemon(
                    id: Int(pokemonEntity.id),
                    name: pokemonEntity.name ?? "",
                    image: pokemonEntity.image ?? URL(string: "https://example.com")!,
                    types: types.map { PokemonType(rawValue: $0.name ?? "")!},
                    hp: Int(pokemonEntity.hp),
                    stats: [
                        .hp : Int(pokemonEntity.hp),
                        .attack : Int(pokemonEntity.attack),
                        .defense : Int(pokemonEntity.defense),
                        .specialAttack : Int(pokemonEntity.specialAttack),
                        .specialDefense : Int(pokemonEntity.specialDefense),
                        .speed : Int(pokemonEntity.speed)
                    ]
                )
            } else {
                // Récupérer depuis l'API et sauvegarder dans CoreData
                let rawPokemon = try await pokemonService.fetchPokemon(name: name)
                let stats = Dictionary(uniqueKeysWithValues: rawPokemon.stats.map { ($0.stat.name, $0.baseStat) })
                
                let pokemon = Pokemon(
                    id: rawPokemon.id,
                    name: rawPokemon.name,
                    image: URL(string: rawPokemon.sprites.other.official.frontDefault)!,
                    types: rawPokemon.types.map(\.type.name),
                    hp: stats[PokemonStatsType.hp] ?? 0,
                    stats: stats
                )
                
                // Créer une nouvelle entité pour la persistance
                let newPokemonEntity = PokemonEntity(context: viewContext)
                newPokemonEntity.id = Int64(pokemon.id)
                newPokemonEntity.name = pokemon.name
                newPokemonEntity.image = pokemon.image
                newPokemonEntity.hp = Int64(pokemon.hp)
                newPokemonEntity.attack = Int64(pokemon.stats[.attack] ?? 0)
                newPokemonEntity.defense = Int64(pokemon.stats[.defense] ?? 0)
                newPokemonEntity.specialAttack = Int64(pokemon.stats[.specialAttack] ?? 0)
                newPokemonEntity.specialDefense = Int64(pokemon.stats[.specialDefense] ?? 0)
                newPokemonEntity.speed = Int64(pokemon.stats[.speed] ?? 0)

                // Maintenant, on ajoute tout en une seule fois
                newPokemonEntity.types = []
                
                // Sauvegarder dans CoreData
                try viewContext.save()
                
                return pokemon
            }
        } catch {
            print("❌ Erreur lors de la récupération du Pokémon: \(error)")
            throw error
        }
    }
}
