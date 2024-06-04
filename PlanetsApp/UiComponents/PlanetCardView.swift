//
//  PosterImage.swift
//  PlanetsApp
//
//  Created by rescalon on 1/4/24.
//

import SwiftUI

struct PlanetCardView<Content: View>: View {
    let planet: Planet
    let favoriteButtonContent: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            descriptionContent
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(12)
    }
    
    // MARK: - Views
    var header : some View {
        HStack {
            Text(planet.name)
                .font(.largeTitle)
                .bold()
                .padding(.top, 8)
            Spacer()
            
            AsyncImage(url: URL(string: planet.imageUrl ?? "")) { image in
                image.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
        }
    }
    
    @ViewBuilder
    var descriptionContent : some View {
        Text(planet.description)
            .padding(.vertical, 8)
            .lineLimit(3)
        HStack {
            Spacer()
            favoriteButtonContent()
        }
    }
}

#Preview {
    PlanetCardView(
        planet: Planet(
            id: 0, 
            name: "Earth Planet",
            imageName: "earth2",
            imageUrl: "",
            overview: "quick overview", 
            description: "This is the description of what we will do on this screen. It is multiple lines and we will align the text to the leading edge.",
            isFavorite: true,
            category: "Rocky",
            satellites: 0
        ),
        favoriteButtonContent: {
            SimpleFavoriteView(isFavorite: true)
                .padding()
        }
    )
}
