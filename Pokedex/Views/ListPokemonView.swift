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
    
    @State var pokemonToShow: Pokemon? = nil
    @State var showSheet = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.pokemons) { pokemon in
                    HStack {
                        KFImage(pokemon.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        
                        Text(pokemon.name)
                    }
                    .task {
                        if (pokemon.id == viewModel.pokemons.last?.id) {
                            await viewModel.loadPokemons()
                        }
                    }
                    .onTapGesture {
                        pokemonToShow = pokemon
                        showSheet.toggle()
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Pokemon Collection")
        .sheet(isPresented: $showSheet, content: {
            if let pokemon = pokemonToShow {
                PokemonDetailView(pokemon: pokemon)
            }
        })
        .task {
            await viewModel.loadPokemons()
        }
    }
}

#Preview {
    ListPokemonView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
