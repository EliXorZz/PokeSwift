//
//  Pokemon.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI

struct PokemonList: Codable {
    let next: String?
    let previous: String?
    
    let results: [Item]
    
    struct Item: Identifiable, Codable {
        var id: String { self.name }
        
        let name: String
        let url: String
    }
    
    func haveNext() -> Bool {
        self.next != nil
    }
    
    func havePrevious() -> Bool {
        self.previous != nil
    }
}

struct PokemonAPI: Codable, Identifiable {
    let id: Int
    let name: String
    
    let sprites: Sprites
    
    struct Sprites: Codable {
        let other: Other
        
        struct Other: Codable {
            let official: Official
            
            struct Official: Codable {
                let frontDefault: String
            }
            
            enum CodingKeys: String, CodingKey {
                case official = "official-artwork"
            }
        }
    }
}

class PokemonService {
    static func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonList {
        let queries = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        
        var url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        url.append(queryItems: queries)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(PokemonList.self, from: data)
    }

    static func fetchPokemon(name: String) async throws -> Pokemon {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let pokemonAPI = try decoder.decode(PokemonAPI.self, from: data)
        
        return Pokemon(
            id: pokemonAPI.id,
            name: pokemonAPI.name,
            image: URL(string: pokemonAPI.sprites.other.official.frontDefault)!,
            
            types: []
        )
    }

}
