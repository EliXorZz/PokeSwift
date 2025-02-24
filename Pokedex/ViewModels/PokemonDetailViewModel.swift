//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//
import Foundation
import CoreData

class PokemonDetailViewModel: ObservableObject {
    @Published var showingFightView = false
    @Published var isFavorite = false
}
