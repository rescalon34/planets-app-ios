//
//  PlanetGridItem.swift
//  PlanetsApp
//
//  Created by rescalon on 29/3/24.
//

import SwiftUI

// https://talk.objc.io/episodes/S01E309-building-a-photo-grid-square-grid-cells
// see above link for more info on how to scale images.
struct PlanetGridItem<Content: View>: View {
    var planet: Planet
    let favoriteButtonContent: () -> Content
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                imageContainer
                textCaptionContainer
            }
        }
        .cornerRadius(16)
        .shadow(radius: 4)
    }
    
    // MARK: - Views
    @ViewBuilder
    var imageContainer : some View {
        VStack {
            AsyncImage(url: URL(string: planet.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                
            } placeholder: {
                Image("empty_planet")
                    .resizable(resizingMode: .tile)
            }
        }
    }
    
    @ViewBuilder
    var textCaptionContainer : some View {
        VStack(alignment: .leading) {
            HStack {
                Text(planet.name)
                    .font(.headline)
                    .lineLimit(1)
                    .bold()
                Spacer()
                favoriteButtonContent()
            }
            
            Text(planet.overview).lineLimit(1)
        }
        .padding()
    }
}

#Preview {
    PlanetGridItem(
        planet: HomeViewModel().previewPlanets[0],
        favoriteButtonContent: {
            SimpleFavoriteView(isFavorite: true)
        }
    )
}
