//
//  PokemonFightView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//

import SwiftUI

struct PokemonFightView: View {
    
    @StateObject var viewModel : PokemonFightViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: PokemonFightViewModel(pokemon: pokemon))
    }
    
    
    var body: some View {
        Group {
            if viewModel.randomPokemon == nil {
                ProgressView()
            } else {
                FightContentView(
                    viewModel: viewModel,
                    performAttack: performAttack,
                    dismiss: dismiss
                )
            }
        }.onAppear {
            Task {
                await viewModel.load()  // Charge les données au premier affichage
            }
        }
    }
    
    func performAttack() {
        guard let randomPokemon = viewModel.randomPokemon else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
            viewModel.showingAttackAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewModel.showingAttackAnimation = false
            if viewModel.currentTurn == 1 {
                viewModel.pokemon2HP = max(0, viewModel.pokemon2HP - (viewModel.currentPokemon!.stats[PokemonStatsType.attack] ?? 0))
                viewModel.currentTurn = 2
            } else {
                viewModel.pokemon1HP = max(0, viewModel.pokemon1HP - (randomPokemon.stats[PokemonStatsType.attack] ?? 0))
                viewModel.currentTurn = 1
            }
            if viewModel.pokemon1HP == 0 || viewModel.pokemon2HP == 0 {
                viewModel.finished = true
            }
        }
    }

}
    
private struct FightContentView: View {
    @ObservedObject var viewModel: PokemonFightViewModel
    let performAttack: () -> Void
    let dismiss: DismissAction
    
    var body: some View {
        
        VStack {
            // En-tête avec les barres de vie
            HStack(spacing: 20) {
                PokemonStatusView(pokemon: viewModel.currentPokemon!, currentHP: viewModel.pokemon1HP)
                Spacer()
                PokemonStatusView(pokemon: viewModel.randomPokemon!, currentHP: viewModel.pokemon2HP)
            }
            .padding()
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.gray.opacity(0.2), .gray.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                HStack(spacing: 50) {
                    AsyncImage(url: viewModel.currentPokemon!.image) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                            .offset(x: viewModel.showingAttackAnimation && viewModel.currentTurn == 1 ? 20 : 0)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    AsyncImage(url: viewModel.randomPokemon!.image) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                            .offset(x: viewModel.showingAttackAnimation && viewModel.currentTurn == 2 ? -20 : 0)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .frame(maxHeight: .infinity)
            
            VStack(spacing: 15) {
                Button("Attaquer") {
                    performAttack()
                }
                .font(.title3.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    Group {
                        if !viewModel.finished {
                            LinearGradient(
                                gradient: Gradient(colors: [viewModel.currentPokemon!.types.first?.color ?? .red, viewModel.currentPokemon!.types.last?.color ?? .red]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color.gray.opacity(0.5)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .disabled(viewModel.finished)
                
                if !viewModel.finished {
                    Button("Fuir") {
                        viewModel.finished = true
                    }
                    .font(.title3)
                    .foregroundColor(.gray)
                    
                }
                else {
                    Button("Partir") {
                        dismiss()
                    }
                    .font(.title3)
                    .foregroundColor(viewModel.currentPokemon!.types.first?.color ?? .red)
                }
            }
            .padding()
        }
        .background(Color.white)
    }
}
    
struct PokemonStatusView: View {
    let pokemon: Pokemon
    let currentHP: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(pokemon.name.capitalized)
                .font(.headline)
            
            // Barre de vie
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 100, height: 8)
                    .foregroundColor(.gray.opacity(0.3))
                
                Rectangle()
                    .frame(width: 100 * CGFloat(currentHP) / CGFloat(pokemon.hp), height: 8)
                    .foregroundColor(healthColor)
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            Text("HP: \(currentHP)/\(pokemon.hp)")
                .font(.caption)
        }
    }
    
    private var healthColor: Color {
        let percentage = Double(currentHP) / Double(pokemon.hp)
        switch percentage {
        case 0.7...: return .green
        case 0.3...: return .yellow
        default: return .red
        }
    }
}
