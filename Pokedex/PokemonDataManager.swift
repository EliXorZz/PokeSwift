//
//  CoreDataService.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import CoreData

class PokemonDataManager {
    
    static let shared = PokemonDataManager()
    let container: NSPersistentContainer
    
    init() {
            container = NSPersistentContainer(name: "PokemonModel")
            container.loadPersistentStores { description, error in
                if let error = error {
                    print("Erreur CoreData: \(error)")
                }
            }
        }
    
    
    func savePokemon(_ pokemon: Pokemon) {
        let context = container.viewContext
        let newData = PokemonEntity(context: context)
        
        newData.id = Int64(pokemon.id)
        newData.name = pokemon.name + "h"
        newData.image = pokemon.image
        
        do {
            try context.save()
        } catch {
            print("error-Saving data")
        }
    }
    
    
    func fetchPokemons() -> [Pokemon] {
        let context = container.viewContext
        let request = NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
        
        do {
            let entities = try context.fetch(request)
            return entities.map { Pokemon(id: Int($0.id), name: $0.name!, image: $0.image!, types: [] ) }
        } catch {
            print("Erreur lecture: \(error)")
            return []
        }
    }
}
