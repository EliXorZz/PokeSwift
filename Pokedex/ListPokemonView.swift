//
//  ListPokemonView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI

struct ListPokemonView: View {
    @State private var pokemons: [Pokemon] = [
        Pokemon(id: 1, name: "Pikachu", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
    ]
    
    var body: some View {
        List {
            VStack {
                ForEach(pokemons) { pokemon in
                    
                    HStack {
                        AsyncImage(url: URL(string: pokemon.imageURL)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                        } placeholder: {
                                            ProgressView()
                                        }
                            Text(pokemon.name)
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
