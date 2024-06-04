//
//  PlanetFeaturedItem.swift
//  PlanetsApp
//
//  Created by rescalon on 20/4/24.
//

import SwiftUI

struct PlanetFeaturedItem<Content: View>: View {
    let imageUrl: String
    let imageName: String
    let favoriteContentView: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            imageContainer
            textCaptionContainer
        }
        .padding(.trailing, 15)
    }
    
    var imageContainer : some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 180)
                .clipped()
                .cornerRadius(8)
                .shadow(radius: 1)
        } placeholder: {
            Image("empty_planet")
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 180)
                .clipped()
                .cornerRadius(8)
                .shadow(radius: 1)
        }
    }
    
    var textCaptionContainer : some View {
        VStack(alignment: .leading) {
            HStack {
                Text(imageName)
                    .font(.callout)
                    .lineLimit(1)
                    .bold()
                Spacer()
                favoriteContentView()
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    PlanetFeaturedItem(
        imageUrl: "https://upload.wikimedia.org/wikipedia/commons/0/02/OSIRIS_Mars_true_color.jpg",
        imageName: "Mars",
        favoriteContentView: {
            SimpleFavoriteView(isFavorite: true)
        }
    )
}
