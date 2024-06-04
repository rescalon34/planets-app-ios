//
//  CircleFavoriteButton.swift
//  PlanetsApp
//
//  Created by rescalon on 1/4/24.
//

import SwiftUI

struct CircleFavoriteButton: View {
    let isFavorite: Bool
    @Binding var shouldAnimate: Bool
    var gradientColors: [Color] = [Color.red, Color.pink, Color.pink.opacity(0.2)]
    
    var body: some View {
        Image(systemName: isFavorite ? "heart.fill" : "heart")
            .scaleEffect(shouldAnimate ? 1.3 : 1)
            .foregroundColor(.white)
            .background(
                Circle()
                    .fill(
                        .linearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(
                        width: 50,
                        height: 50
                    )
                    .shadow(color: gradientColors.first ?? Color.black, radius: 10, x: 0, y: 6)
                
            )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CircleFavoriteButton(isFavorite: true, shouldAnimate: .constant(true), gradientColors: [Color.red, Color.pink, Color.pink.opacity(0.2)])
        .padding(.all, 50)
}
