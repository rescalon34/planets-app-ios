//
//  PlanetPosterItem.swift
//  PlanetsApp
//
//  Created by rescalon on 29/3/24.
//

import SwiftUI

struct PlanetPosterItem<Content: View>: View {
    var planet: Planet
    let favoriteButtonContent: () -> Content
    
    // MARK: - Body
    var body: some View {
        VStack {
            imageContainer
            textCaptionContainer
        }
    }
    
    // MARK: - Views
    var imageContainer : some View {
        VStack {
            AsyncImage(url: URL(string: planet.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 180, maxHeight: 180)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(radius: 1)
                
            } placeholder: {
                Image("empty_planet")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 180, maxHeight: 180)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(radius: 1)
            }
        }
    }
    
    var textCaptionContainer : some View {
        VStack(alignment: .leading) {
            HStack {
                Text(planet.name)
                    .font(.caption)
                    .lineLimit(1)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
                favoriteButtonContent()
            }
            
            Text(planet.overview)
                .lineLimit(1)
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.top, 2)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    PlanetPosterItem(
        planet: HomeViewModel().previewPlanets[0],
        favoriteButtonContent: {
            SimpleFavoriteView(isFavorite: true)
        }
    )
}
