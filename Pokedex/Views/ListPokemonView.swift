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
    
    var body: some View {
        List(viewModel.pokemons) { pokemon in
            VStack {
                HStack {
                    KFImage(pokemon.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    Text(pokemon.name)
                }
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
