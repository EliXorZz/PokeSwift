//
//  ContentView.swift
//  Pokedex
//
//  Created by Dylan on 17/02/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView {
            ListPokemonView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
