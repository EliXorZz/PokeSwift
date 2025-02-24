//
//  PokemonFightView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//

import SwiftUI

struct PokemonFightView: View {
    let pokemon: Pokemon
    let randomPokemon: Pokemon
    
    @State private var pokemon1HP: Int
    @State private var pokemon2HP: Int
    @State private var showingAttackAnimation = false
    @State private var currentTurn = 1 // 1 pour pokemon, 2 pour randomPokemon
    
    init(pokemon: Pokemon, randomPokemon: Pokemon) {
        self.pokemon = pokemon
        self.randomPokemon = randomPokemon
        _pokemon1HP = State(initialValue: pokemon.hp)
        _pokemon2HP = State(initialValue: randomPokemon.hp)
    }
    
    var body: some View {
        VStack {
            // En-tête avec les barres de vie
            HStack(spacing: 20) {
                PokemonStatusView(pokemon: pokemon, currentHP: pokemon1HP)
                Spacer()
                PokemonStatusView(pokemon: randomPokemon, currentHP: pokemon2HP)
            }
            .padding()
            
            // Zone de combat
            ZStack {
                // Fond
                LinearGradient(
                    gradient: Gradient(colors: [.gray.opacity(0.2), .gray.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Pokémon qui combattent
                HStack(spacing: 50) {
                    // Pokémon du joueur
                    AsyncImage(url: pokemon.image) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                            .offset(x: showingAttackAnimation && currentTurn == 1 ? 20 : 0)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    // Pokémon adverse
                    AsyncImage(url: randomPokemon.image) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                            .offset(x: showingAttackAnimation && currentTurn == 2 ? -20 : 0)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .frame(maxHeight: .infinity)
            
            // Boutons d'action
            VStack(spacing: 15) {
                Button("Attaquer") {
                    performAttack()
                }
                .font(.title3.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [pokemon.types.first?.color ?? .red, pokemon.types.last?.color ?? .red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Button("Fuir") {
                    // Action pour fuir
                }
                .font(.title3)
                .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.white)
    }
    
    private func performAttack() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
            showingAttackAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showingAttackAnimation = false
            if currentTurn == 1 {
                pokemon2HP = max(0, pokemon2HP - pokemon.strength)
                currentTurn = 2
            } else {
                pokemon1HP = max(0, pokemon1HP - randomPokemon.strength)
                currentTurn = 1
            }
        }
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

#Preview {
    PokemonFightView(pokemon: Pokemon(
        id: 1,
        name: "Bulbasaur",
        image: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png")!,
        types: [.dark, .fire],  // Simplification de la syntaxe pour les types
        hp: 50,
        stats : [
            .hp: 70,
            .attack: 40,
            .defense: 40,
            .speed: 60
        ]
    ),
     randomPokemon: Pokemon(
        id: 2,
        name: "Bulbasaur",
        image: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/50.png")!,
        types: [.bug, .fighting],  // Simplification de la syntaxe pour les types
        hp: 70,
        stats : [
            .hp: 70,
            .attack: 20,
            .defense: 50,
            .speed: 30
        ]
    ))
}
