//
//  PlanetCardSegments.swift
//  PlanetsApp
//
//  Created by rescalon on 18/4/24.
//

import Foundation

enum PlanetCardSegments : CaseIterable {
    case All, Favorites
    
    var option: String {
        switch self {
        case .All:
            "All"
        case .Favorites:
            "Favorites"
        }
    }
}
