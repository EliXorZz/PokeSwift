//
//  ListPokemonView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI

struct ListPokemonView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
        List(viewModel.pokemonItems) { item in
            VStack {
                if let pokemon = viewModel.pokemons[item.name] {
                    HStack {
                        AsyncImage(url: pokemon.image) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                            
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(pokemon.name)
                    }
                }else {
                    ProgressView()
                }
            }.task {
                await viewModel.loadPokemon(name: item.name)
            }
        }.task {
            await viewModel.loadPokemons()
        }
    }
}

#Preview {
    ListPokemonView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
