//
//  Pokemon.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI

class PokemonService {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonListAPI {
        let queries = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        
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
