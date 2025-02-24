//
//  Pokemon.swift
//  Pokedex
//
//  Created by Dylan on 17/02/2025.
//

import Foundation

enum PokemonType: String {
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

struct Pokemon: Identifiable {
    let id: Int
    let name: String
    
    let image: URL
    
    let types: [PokemonType]
    
    let hp: Int
    let strength: Int
    let defense: Int
    let speed: Int
}
