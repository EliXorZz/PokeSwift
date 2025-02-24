//
//  Pokemon.swift
//  Pokedex
//
//  Created by Dylan on 17/02/2025.
//

import Foundation

enum PokemonType: String, Codable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case stellar
    case unknown
}

enum PokemonStatsType: String, Codable {
    case hp
    case attack
    case defense
    case specialAttack
    case specialDefense
    case speed
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "special-attack":
            self = .specialAttack
        case "special-defense":
            self = .specialDefense
        default:
            self = PokemonStatsType(rawValue: rawValue)!
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .specialAttack:
            try container.encode("special-attack")
        case .specialDefense:
            try container.encode("special-defense")
        default:
            try container.encode(self.rawValue)
        }
    }
}

struct Pokemon: Identifiable {
    let id: Int
    let name: String
    
    let image: URL
    
    let types: [PokemonType]
    
    let hp: Int
    
    let stats: [PokemonStatsType: Int]
}
