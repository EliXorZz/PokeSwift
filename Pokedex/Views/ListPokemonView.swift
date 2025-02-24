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
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.pokemons) { pokemon in
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
                }
            }
            .padding()
        }.task {
            await viewModel.loadPokemons()
        }
    }
}

#Preview {
    ListPokemonView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
