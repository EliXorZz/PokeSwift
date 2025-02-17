//
//  Pokemon.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI

struct Pokemon: Decodable, Identifiable {
    let id: Int
    let name: String
    let image: String
    //let types: [String]
    //let stats: [String: Int]
}

func fetchPokemon() async throws -> [Pokemon] {
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0")!
    let (data, _) = try await URLSession.shared.data(from: url)
    print(data)
    return try JSONDecoder().decode([Pokemon].self, from: data)
}
