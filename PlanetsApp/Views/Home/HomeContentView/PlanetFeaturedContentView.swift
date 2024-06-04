//
//  PlanetFeaturedContentView.swift
//  PlanetsApp
//
//  Created by rescalon on 20/4/24.
//

import SwiftUI

struct PlanetFeaturedContentView: View {
    
    // MARK: - Properties.
    @ObservedObject var homeViewModel : HomeViewModel
    
    var body: some View {
        featuredPlanetsContent
            .onAppear {
                homeViewModel.setupCarouselTimer()
            }
            .onDisappear {
                homeViewModel.cancelCaouselTimer()
            }
    }
    
    // MARK: - Views.
    var featuredPlanetsContent : some View {
        List {
            ImagesCarouselTabView(
                carouselSelection: $homeViewModel.carouselCounter,
                carouselHeigth: getCarouselHeight(),
                planets: homeViewModel.getFavoritePlanets()
            )
            .listRowInsets(EdgeInsets())
            .animation(.default, value: homeViewModel.carouselCounter)
            categoriesWithItemsContent
        }
        .listStyle(.sidebar)
    }
    
    /// This view contains all planets for a particular category. The content will be
    /// shown as a horizontal scrollView.
    var categoriesWithItemsContent : some View {
        ForEach(homeViewModel.planetCategories, id: \.self) { category in
            let planets = homeViewModel.getPlanetsByCategory(category: category)
            
            if !planets.isEmpty {
                VStack(alignment: .leading) {
                    Text(category)
                        .font(.headline)
                        .bold()
                        .padding(.horizontal, 4)
                        .padding(.top, 20)
                    setHorizontalItemsByCategory(planetsByCategory: planets)
                }
                .listRowInsets(EdgeInsets())
                .padding(.bottom)
            }
        }
    }
    
    // MARK: - Functions.
    /// This function represents the horizontal planets by category.
    /// - Parameter planetsByCategory: the filtered list of planets by category.
    /// - Returns: The whole horizontal planets view by category.
    func setHorizontalItemsByCategory(planetsByCategory: [Planet]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(planetsByCategory) { planet in
                    NavigationLink {
                        PlanetDetailScreenView(planet: planet, homeViewModel: homeViewModel)
                    } label: {
                        PlanetFeaturedItem(
                            imageUrl: planet.imageUrl ?? "",
                            imageName: planet.name,
                            favoriteContentView: {
                                Button(action: {
                                    withAnimation(.snappy) {
                                        homeViewModel.toggleFavoriteItem(planet: planet)
                                    }
                                }, label: {
                                    SimpleFavoriteView(isFavorite: planet.isFavorite)
                                    
                                })
                            }
                        )
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    func getCarouselHeight() -> CGFloat {
        var heigth :CGFloat = 240
        if UIDevice.current.userInterfaceIdiom == .pad {
            heigth = 450
        }
        return heigth
    }
}

#Preview {
    PlanetFeaturedContentView(homeViewModel: HomeViewModel())
}
