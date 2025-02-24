//
//  PokemonList.swift
//  Pokedex
//
//  Created by Dylan on 24/02/2025.
//

struct PokemonListAPI: Codable {
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
