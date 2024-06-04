//
//  PlanetGridContentView.swift
//  PlanetsApp
//
//  Created by rescalon on 19/4/24.
//

import SwiftUI

struct PlanetGridContentView: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    
    // MARK: - view list configurations.
    //  2 items - Adaptive.
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 8),
    ]
    
    // 3 items - Poster Adaptive.
    private let posterAdaptiveColumn = [
        GridItem(.adaptive(minimum: 90, maximum: .infinity), spacing: 8),
    ]
    
    // 2 items - Fixed.
    private let fixed = [
        GridItem(.fixed(150), spacing: 8),
        GridItem(.fixed(150), spacing: 8),
    ]
    
    // 2 items - Flexible.
    // Recommended to fit on iphone and iPads as well.
    private let flexible = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        planetGridList
    }
    
    // MARK: - Views.
    var planetGridList : some View {
        ScrollView {
            LazyVGrid(
                columns: flexible,
                spacing: 20,
                pinnedViews: [.sectionHeaders]
            ) {
                ForEach(homeViewModel.planetCategories, id: \.self) { category in
                    if homeViewModel.arePlanesForThisCategory(category: category) {
                        Section(
                            header: HeaderSection(sectionTitle: category)
                        ) {
                            ForEach(homeViewModel.getPlanetsByCategory(category: category)) { planet in
                                NavigationLink {
                                    PlanetDetailScreenView(planet: planet, homeViewModel: homeViewModel)
                                } label: {
                                    PlanetPosterItem(
                                        planet: planet,
                                        favoriteButtonContent: {
                                            SimpleFavoriteView(isFavorite: planet.isFavorite)
                                                .gesture(TapGesture().onEnded {
                                                    withAnimation(.snappy) {
                                                        homeViewModel.toggleFavoriteItem(planet: planet)
                                                    }
                                                }
                                            )
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // Planets section shown on the planetGridList view Type.
    struct HeaderSection : View {
        var sectionTitle: String = ""
        
        var body: some View {
            Text(sectionTitle)
                .padding(.all, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
                .padding(.horizontal, 8)
                .background(.indigo)
                .cornerRadius(8)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    PlanetGridContentView(homeViewModel: HomeViewModel())
}
