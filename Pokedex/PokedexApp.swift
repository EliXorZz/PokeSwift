//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Dylan on 17/02/2025.
//

import SwiftUI

@main
struct PokedexApp: App {
    let persistenceController = PersistenceController.shared
    


    var body: some Scene {
        WindowGroup {
            ListPokemonView()
            /*
             ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
             */
        }
    }
}
