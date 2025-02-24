//
//  Pokemon.swift
//  Pokedex
//
//  Created by Dylan on 17/02/2025.
//

import Foundation



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
