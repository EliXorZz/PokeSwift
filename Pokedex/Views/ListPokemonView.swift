//
//  ListPokemonView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 17/02/2025.
//

import SwiftUI
import Kingfisher

struct ListPokemonView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredPokemons) { pokemon in
                    PokemonCard(pokemon: pokemon)
                    .task {
                        if (pokemon.id == viewModel.pokemons.last?.id) {
                            await viewModel.loadPokemons()
                        }
                    }
                    .onTapGesture { viewModel.showPokemonSheet(pokemon: pokemon) }
                }
            }
            .padding()
        }
        .navigationBarTitle("Pokemon Collection")
        .sheet(isPresented: $viewModel.showSheet){
            if let pokemon = viewModel.pokemonToShow {
                PokemonDetailView(pokemon: pokemon)
            }
        }
        .task {
            await viewModel.loadPokemons()
        }
        .searchable(text: $viewModel.searchQuery, prompt: "Rechercher un pokémon")
    }
}

struct PokemonCard: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            Text(pokemon.name.capitalized)
                .foregroundStyle(.white)
                .fontWeight(Font.Weight.bold)
            
            Spacer()
                .frame(height: 10)
            
            KFImage(pokemon.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(
            LinearGradient(gradient: Gradient(colors: [pokemon.types.first?.color ?? .white, .white]), startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

#Preview {
    ListPokemonView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
