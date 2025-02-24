//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    @State private var showingFightView = false
    
    private var backgroundColor: Color {
        pokemon.types.first?.color.opacity(0.2) ?? .clear
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header avec boutons
                HStack {
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavorite ? .red : .gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Image et nom
                AsyncImage(url: pokemon.image) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                }
                
                Text(pokemon.name.capitalized)
                    .font(.title)
                    .bold()
                
                // Types
                HStack(spacing: 10) {
                    ForEach(pokemon.types, id: \.self) { type in
                        Text(type.label)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(type.color)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                
                // Stats
                VStack(spacing: 15) {
                    StatGroup(name: "HP", value: pokemon.hp, color: .green)
                    //StatGroup(name: "Attack", value: pokemon.strength, color: .red)
                    //StatGroup(name: "Defense", value: pokemon.defense, color: .blue)
                    //StatGroup(name: "Speed", value: pokemon.speed, color: .orange)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                
                // Bouton Combat
                Button(action: {
                    showingFightView = true
                }) {
                    Text("Commencer le combat")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [pokemon.types.first?.color ?? .blue, (pokemon.types.last ?? pokemon.types.first)?.color ?? .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .padding(.vertical)
            .sheet(isPresented: $showingFightView) {
                        PokemonFightView(
                            pokemon: pokemon,
                            randomPokemon: Pokemon(
                                id: 2,
                                name: "Bulbasaur",
                                image: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/50.png")!,
                                types: [.bug, .fighting],
                                hp: 70,
                                strength: 20,
                                defense: 50,
                                speed: 30
                            )
                        )
                    }
        }
        .background(backgroundColor)
        .navigationBarHidden(true)
    }
    
    private struct StatGroup: View {
        let name: String
        let value: Int
        let color: Color
        
        var body: some View {
            HStack {
                Text(name)
                    .frame(width: 80, alignment: .leading)
                    .font(.system(.body, design: .monospaced))
                
                Text("\(value)")
                    .frame(width: 40, alignment: .trailing)
                    .font(.system(.body, design: .monospaced))
                
                StatBar(value: value, maxValue: 100, color: color)
                    .frame(height: 20)
            }
        }
    }
}

struct StatBar: View {
    let value: Int
    let maxValue: Int
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 20)
                    .opacity(0.3)
                    .foregroundColor(color)
                
                Rectangle()
                    .frame(width: min(CGFloat(value) / CGFloat(maxValue) * geometry.size.width, geometry.size.width), height: 20)
                    .foregroundColor(color)
                    .animation(.spring, value: value)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    /*PokemonDetailView(pokemon: Pokemon(
        id: 1,
        name: "Bulbasaur",
        image: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png")!,
        types: [.dark, .fire],  // Simplification de la syntaxe pour les types
        hp: 50,
        strength: 40,
        defense: 40,
        speed: 60
    ))*/
}
