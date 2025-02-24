//
//  PokemonAPI.swift
//  Pokedex
//
//  Created by Dylan on 24/02/2025.
//

struct PokemonAPI: Codable, Identifiable {
    let id: Int
    let name: String
    
    let types: [Types]
    let stats: [Stats]
    
    let sprites: Sprites
    
    struct Types: Codable {
        let slot: Int
        let type: Current
        
        struct Current: Codable {
            let name: PokemonType
        }
    }
    
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
    
    struct Stats: Codable {
        let baseStat: Int
        let effort: Int
        
        let stat: Stat
        
        struct Stat: Codable {
            let name: PokemonStatsType
        }
    }
}
