//
//  ListPokemonView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI

struct ListPokemonView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @State var pokemonDetailOpen: Bool = false
    @State var pokemonToShow: Pokemon? = nil
    
    var body: some View {
        NavigationStack {
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
                        .onTapGesture {
                            pokemonToShow = pokemon
                            pokemonDetailOpen.toggle()
                        }
                        
                    }else {
                        ProgressView()
                    }
                }
                .task {
                    await viewModel.loadPokemon(name: item.name)
                }
            }.task {
                await viewModel.loadPokemons()
            }
            .navigationBarTitle("Pokemon Collection")
            .toolbar(content: {
                ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                    Button(action: {
                        pokemonDetailOpen.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                    })
                }
            })
            .sheet(isPresented: $pokemonDetailOpen, content: {
                    if let pokemon = pokemonToShow {
                        PokemonDetailView(pokemon: pokemon)
                    }
                })
        }
    }
}

#Preview {
    ListPokemonView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
