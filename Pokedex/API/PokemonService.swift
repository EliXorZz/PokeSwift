//
//  Pokemon.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI

class PokemonService {
    func fetchPokemonList(limit: Int, offset: Int, search: String? = nil) async throws -> PokemonListAPI {
        var queries = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        
        if let search = search, !search.isEmpty {
          queries.append(
            URLQueryItem(name: "search", value: search)
          )
        }
        
        var url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        url.append(queryItems: queries)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(PokemonListAPI.self, from: data)
    }

    func fetchPokemon(name: String) async throws -> PokemonAPI {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(PokemonAPI.self, from: data)
    }
}
