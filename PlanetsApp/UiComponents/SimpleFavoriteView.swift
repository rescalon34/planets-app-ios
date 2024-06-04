//
//  SimpleFavoriteView.swift
//  PlanetsApp
//
//  Created by rescalon on 4/4/24.
//

import SwiftUI

struct SimpleFavoriteView: View {
    let isFavorite: Bool
    
    var body: some View {
        Image(systemName: isFavorite ? "heart.fill" : "heart")
            .scaleEffect(isFavorite ? 1.3 : 1)
            .symbolRenderingMode(.multicolor)
    }
}

#Preview {
    SimpleFavoriteView(isFavorite: true)
}
