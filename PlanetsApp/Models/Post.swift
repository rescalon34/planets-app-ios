//
//  Post.swift
//  PlanetsApp
//
//  Created by rescalon on 18/5/24.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    
    static var `default`: Self = .init(id: 0, title: "", body: "")
    
    init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body = "body"
    }
}
