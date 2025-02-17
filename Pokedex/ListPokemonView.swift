//
//  ListPokemonView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI

struct ListPokemonView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokemons: FetchedResults<PokemonEntity>
    
    var body: some View {
        List {
            VStack {
                ForEach(pokemons) { pokemon in
                    
                    HStack {
                        AsyncImage(url: URL(string: pokemon.image ?? "")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                        } placeholder: {
                                            ProgressView()
                                        }
                            Text(pokemon.name ?? "")
                            }
                }
                .task {
                    /*if let fetchedPokemons = try? await fetchPokemon() {
                        self.pokemons = fetchedPokemons
                        print("Fetched \(pokemons.count) favorites.")
                    } else {
                        print("Failed to fetch favorites.")
                    }*/
                }
            }
        }
    }
}

#Preview {
    ListPokemonView()
}
