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
    private let notificationManager = NotificationManager()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredPokemons) { pokemon in
                    PokemonCard(pokemon: pokemon, viewModel: viewModel)
                        .task {
                            if (pokemon.id == viewModel.filteredPokemons.last?.id) {
                                await viewModel.loadPokemons()
                            }
                        }
                        .onTapGesture { viewModel.pokemonToShow = pokemon }
                }
            }
            .padding()
        }
        .navigationBarTitle("Collection pokémon")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Tri", selection: $viewModel.orderType) {
                        ForEach(OrderType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(OrderType?.some(type))
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Type", selection: $viewModel.filterType) {
                      Text("Tous les types").tag(PokemonType?.none)
                        
                        ForEach(PokemonType.allCases, id: \.self) { type in
                            Text(type.label).tag(PokemonType?.some(type))
                        }
                    }
                } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }
        }
        .sheet(
            isPresented: Binding<Bool>(
                get: { viewModel.pokemonToShow != nil },
                set: { _ in viewModel.pokemonToShow = nil }
            )
        ){
            if let pokemon = viewModel.pokemonToShow {
                PokemonDetailView(pokemon: pokemon)
            }
        }
        .task {
            await viewModel.loadPokemons()
            
            if let pokemon = viewModel.pokemons.first {
                notificationManager.requestPermission()
                notificationManager.scheduleDailyPokemonNotification(pokemon: pokemon)
            }
        }
        .searchable(text: $viewModel.searchQuery, prompt: "Rechercher un pokémon")
    }
}

    
struct PokemonCard: View {
    let pokemon: Pokemon
    let viewModel: PokemonListViewModel
    @State private var isClicked = false
    
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
                .saturation(isClicked ? 0.5 : 1.0) // Réduire la saturation lors du clic
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        isClicked ? (pokemon.types.first?.color.opacity(0.6) ?? .gray) : (pokemon.types.first?.color ?? .white),
                        isClicked ? .gray.opacity(0.7) : .white
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(10)
        .shadow(radius: 3)
        .onTapGesture {
            // Effet grisâtre
            withAnimation(.easeInOut(duration: 0.2)) {
                isClicked = true
            }
            
            // Rétablir après un court délai
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isClicked = false
                }
                
                // Exécuter l'action originale après l'animation
                viewModel.pokemonToShow = pokemon
            }
        }
    }
}

#Preview {
    ListPokemonView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
