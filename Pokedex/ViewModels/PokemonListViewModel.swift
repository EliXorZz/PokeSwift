//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Dylan on 17/02/2025.
//

import Foundation
import CoreData

enum OrderType: String, CaseIterable {
    case id
    case alphanumeric
    case hp
    case attack
    case defense
    case specialAttack
    case specialDefense
    case speed
}

class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    
    @Published var pokemonToShow: Pokemon? = nil
    
    @Published var searchQuery = ""
    
    @Published var filterType: PokemonType? = nil
    @Published var orderType: OrderType = .id
    
    var filteredPokemons: [Pokemon] {
        var pokemons: [Pokemon] = pokemons
        
        if !searchQuery.isEmpty {
            pokemons = pokemons
                .filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
        
        if let filter = filterType {
            pokemons = pokemons
                .filter { $0.types.contains(filter) }
        }
        
        return pokemons.sorted {
            switch orderType {
            case .id:
                $0.id < $1.id
            case .alphanumeric:
                $0.name < $1.name
            case .hp:
                $0.hp < $1.hp
            case .attack:
                $0.stats[.attack]! < $1.stats[.attack]!
            case .defense:
                $0.stats[.defense]! < $1.stats[.defense]!
            case .specialAttack:
                $0.stats[.specialAttack]! < $1.stats[.specialAttack]!
            case .specialDefense:
                $0.stats[.specialDefense]! < $1.stats[.specialDefense]!
            case .speed:
                $0.stats[.speed]! < $1.stats[.speed]!
            }
        }
    }
    
    private let pokemonRepository = PokemonRepository()
    
    private let limit = 100
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
    
    func toggleFav(pokemon: Pokemon){
        
    }
}
