//
//  PokemonType.swift
//  Pokedex
//
//  Created by Emilien Roukine on 24/02/2025.
//

import SwiftUICore

enum PokemonType: String {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case stellar
    case unknown
    
    var color: Color {
        switch self {
        case .normal:
            return Color(red: 168/255, green: 168/255, blue: 120/255)
        case .fighting:
            return Color(red: 192/255, green: 48/255, blue: 40/255)
        case .flying:
            return Color(red: 168/255, green: 144/255, blue: 240/255)
        case .poison:
            return Color(red: 160/255, green: 64/255, blue: 160/255)
        case .ground:
            return Color(red: 224/255, green: 192/255, blue: 104/255)
        case .rock:
            return Color(red: 184/255, green: 160/255, blue: 56/255)
        case .bug:
            return Color(red: 168/255, green: 184/255, blue: 32/255)
        case .ghost:
            return Color(red: 112/255, green: 88/255, blue: 152/255)
        case .steel:
            return Color(red: 184/255, green: 184/255, blue: 208/255)
        case .fire:
            return Color(red: 240/255, green: 128/255, blue: 48/255)
        case .water:
            return Color(red: 104/255, green: 144/255, blue: 240/255)
        case .grass:
            return Color(red: 120/255, green: 200/255, blue: 80/255)
        case .electric:
            return Color(red: 248/255, green: 208/255, blue: 48/255)
        case .psychic:
            return Color(red: 248/255, green: 88/255, blue: 136/255)
        case .ice:
            return Color(red: 152/255, green: 216/255, blue: 216/255)
        case .dragon:
            return Color(red: 112/255, green: 56/255, blue: 248/255)
        case .dark:
            return Color(red: 112/255, green: 88/255, blue: 72/255)
        case .fairy:
            return Color(red: 238/255, green: 153/255, blue: 172/255)
        case .stellar:
            return Color(red: 76/255, green: 146/255, blue: 195/255)
        case .unknown:
            return Color(red: 104/255, green: 160/255, blue: 144/255)
        }
    }
    
    var label: String {
        switch self {
        case .normal:
            return "Normal"
        case .fighting:
            return "Combat"
        case .flying:
            return "Vol"
        case .poison:
            return "Poison"
        case .ground:
            return "Sol"
        case .rock:
            return "Roche"
        case .bug:
            return "Insecte"
        case .ghost:
            return "Spectre"
        case .steel:
            return "Acier"
        case .fire:
            return "Feu"
        case .water:
            return "Eau"
        case .grass:
            return "Plante"
        case .electric:
            return "Électrik"
        case .psychic:
            return "Psy"
        case .ice:
            return "Glace"
        case .dragon:
            return "Dragon"
        case .dark:
            return "Ténèbres"
        case .fairy:
            return "Fée"
        case .stellar:
            return "Stellaire"
        case .unknown:
            return "Inconnu"
        }
    }
}
