//
//  ImagesCarouselTabView.swift
//  PlanetsApp
//
//  Created by rescalon on 20/4/24.
//

import SwiftUI

struct ImagesCarouselTabView: View {
    @Binding var carouselSelection: Int
    let carouselHeigth: CGFloat
    let planets : [Planet]
    @State var currentGestureValue : CGFloat = 0
    
    var body: some View {
        carouselTabViewContent
    }
    
    var carouselTabViewContent : some View {
        TabView(selection: $carouselSelection) {
            ForEach(0..<planets.count, id: \.self) { index in
                let planet = planets[index]
                makeCarouselImageItem(planet: planet)
                .tag(index)
            }
        }
        .frame(height: carouselHeigth)
        .tabViewStyle(.page)
    }
    
    func makeCarouselImageItem(planet: Planet) -> some View {
        AsyncImage(url: URL(string: planet.imageUrl ?? "")) { image in
             image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1 + currentGestureValue)
                .overlay {
                    TextOverlayView(title: planet.name, caption: planet.overview)
                        .frame(height: carouselHeigth)
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentGestureValue = getMagnificationGestureValue(value: value - 1)
                        }
                        .onEnded { value in
                            withAnimation(.spring) {
                                currentGestureValue = 0
                            }
                        }
                )
        } placeholder: {
            ZStack {
                ProgressView()
                Image("empty_planet")
                    .resizable(resizingMode: .tile)
            }
            .padding(.trailing, 2)
        }
    }
}

#Preview {
    ImagesCarouselTabView(
        carouselSelection: .constant(1),
        carouselHeigth: 230,
        planets: HomeViewModel().previewPlanets)
}
