//
//  PlanetRowItem.swift
//  PlanetsApp
//
//  Created by rescalon on 24/3/24.
//

import SwiftUI

/**
 Reusable RowItem to be display in a List of items.
 
 @param planet where the info will be obtained.
 @param favoriteButtonContent the favorite button view.
 */
struct PlanetRowItem<Content: View>: View {
    var planet: Planet
    let favoriteButtonContent: () -> Content
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: planet.imageUrl ?? "")) { image in
                 image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .planetImageItemModifier()
            } placeholder: {
                ZStack {
                    ProgressView()
                    Image("empty_planet")
                        .resizable(resizingMode: .tile)
                        .planetImageItemModifier()
                }
                .padding(.trailing, 2)
            }
            VStack(alignment: .leading) {
                Text(planet.name)
                    .font(.title3)
                Text(planet.overview)
                    .font(.caption)
            }
            Spacer()
            favoriteButtonContent()
        }
    }
}

#Preview {
    PlanetRowItem(
        planet: HomeViewModel().previewPlanets[2],
        favoriteButtonContent: {
            SimpleFavoriteView(isFavorite: true)
        }
    )
}
