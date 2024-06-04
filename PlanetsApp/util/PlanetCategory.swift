//
//  PlanetCategory.swift
//  PlanetsApp
//
//  Created by rescalon on 30/3/24.
//

import Foundation

enum PlanetCategory: CaseIterable {
    case Rocky, Gaseous, IceGiant, Exoplanet, SuperEarth, OceanWold, Dwarf
    
    var category: String {
        switch self {
        case .Rocky:
            "Rocky"
        case .Gaseous:
            "Gaseous"
        case .IceGiant:
            "Ice Giant"
        case .Exoplanet:
            "Exoplanets"
        case .SuperEarth:
            "Super-Earth"
        case .OceanWold:
            "Ocean World"
        case .Dwarf:
            "Dwarf Planets"
        }
    }
}
