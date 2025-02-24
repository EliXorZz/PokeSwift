//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//

import SwiftUI

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

struct PokemonDetailView: View {
    let pokemon: Pokemon
    
    private var backgroundColor: Color {
        pokemon.types.first?.color.opacity(0.2) ?? .clear
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
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
                    StatGroup(name: "Attack", value: pokemon.strength, color: .red)
                    StatGroup(name: "Defense", value: pokemon.defense, color: .blue)
                    StatGroup(name: "Speed", value: pokemon.speed, color: .orange)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
            }
            .padding()
        }
        .background(backgroundColor.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    PokemonDetailView(pokemon: Pokemon(
        id: 1,
        name: "Bulbasaur",
        image: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png")!,
        types: [.dark, .fire],  // Simplification de la syntaxe pour les types
        hp: 50,
        strength: 40,
        defense: 40,
        speed: 60
    ))
}
