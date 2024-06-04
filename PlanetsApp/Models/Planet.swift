//
//  Planet.swift
//  PlanetsApp
//
//  Created by rescalon on 24/3/24.
//

import Foundation

// Following the MVVM principle, to have a Immutable struct model.
struct Planet: Hashable, Codable, Identifiable {
    let id: Int
    let name: String
    let imageName: String?
    let imageUrl: String?
    let overview: String
    let description: String
    var isFavorite: Bool
    let category: String
    let satellites: Int?
    
    // Decoding json data as API return param names.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageName
        case imageUrl
        case overview
        case description = "descrip_tion"
        case isFavorite
        case category
        case satellites
    }
    
    // no need to do this to decode custom json param keys.
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
//        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
//        self.overview = try container.decode(String.self, forKey: .overview)
//        self.description = try container.decode(String.self, forKey: .description)
//        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
//        self.category = try container.decode(String.self, forKey: .category)
//        self.satellites = try container.decodeIfPresent(Int.self, forKey: .satellites)
//    }
    
    static var `default`: Self = .init(
        name: "",
        imageName: "",
        imageUrl: "",
        overview: "",
        description: "",
        isFavorite: false,
        category: "",
        satellites: nil
    )
    
    init(
        id: Int = UUID().hashValue,
        name: String,
        imageName: String?,
        imageUrl: String?,
        overview: String,
        description: String,
        isFavorite: Bool,
        category: String,
        satellites: Int?
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.overview = overview
        self.description = description
        self.isFavorite = isFavorite
        self.category = category
        self.satellites = satellites
    }
    
    // favorite a new planet.
    func favoritePlanet() -> Planet {
        return Planet(
            id: id,
            name: name,
            imageName: imageName,
            imageUrl: imageUrl,
            overview: overview,
            description: description,
            isFavorite: !isFavorite,
            category: category,
            satellites: satellites
        )
    }
}
