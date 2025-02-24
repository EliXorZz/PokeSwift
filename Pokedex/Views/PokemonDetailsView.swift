//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//

import SwiftUI

struct PokemonDetailsView(pokemon id: Int): View {
    @State var pokemon: Pokemon?
    
    var body: some View {
        Text("Pokémon Details")
    }
}
