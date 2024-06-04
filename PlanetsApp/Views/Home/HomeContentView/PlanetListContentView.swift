//
//  PlanetListContentView.swift
//  PlanetsApp
//
//  Created by rescalon on 19/4/24.
//

import SwiftUI
import Combine

struct PlanetListContentView: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    @Binding var showAddNewPlanetSheet: Bool
    @State var selectedCategory : String? = nil
    @State var searchText: String = ""
    @State private var favoriteID: Planet = .default
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 0.1)
                .background(.white)
            .searchable(text: $searchText, prompt: "Search for a planet")
            categoryCapsuleView
            listContent
        }
    }
    
    // MARK: - Views.
    var categoryCapsuleView : some View {
        ScrollView(.horizontal) {
            HStack {
                setFirstCategoryCapsuleView(category: nil, categoryName: "All")
                ForEach(homeViewModel.planetCategories, id: \.self) { category in
                    setFirstCategoryCapsuleView(category: category, categoryName: category)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    var listContent : some View {
        if !getPlanetsByCategory().isEmpty {
            List(getPlanetsByCategory()) { planet in
                NavigationLink {
                    PlanetDetailScreenView(planet: planet, homeViewModel: homeViewModel)
                } label: {
                    PlanetRowItem(
                        planet: planet,
                        favoriteButtonContent: {
                            SimpleFavoriteView(isFavorite: planet.isFavorite)
                                .gesture(TapGesture().onEnded {
                                    withAnimation(.linear) {
                                        homeViewModel.toggleFavoriteItem(planet: planet)
                                    }
                                }
                            )
                        }
                    )
                }
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation {
                            homeViewModel.removePlanet(planet: planet)
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                .swipeActions(edge:.leading, allowsFullSwipe: true) {
                    Button {
                        withAnimation {
                            homeViewModel.sharePlanet(text: planet.name)
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up.fill")
                    }
                }
            }
            .listStyle(.plain)
        } else {
            CustomUnavailableContentView(
                image: "empty_planet",
                title: "No planets",
                description: "There are no planets for this category yet.",
                ctaContent: {
                    Button("Add a planet") {
                        showAddNewPlanetSheet.toggle()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .font(.headline)
                }
            )
            .padding()
            Spacer()
        }
    }
    
    // MARK: Functions.
    func setFirstCategoryCapsuleView(category: String?, categoryName: String)  -> some View {
        CategoryCapsuleView(isSelected: self.selectedCategory == category, categoryName: categoryName)
            .onTapGesture {
                withAnimation(.default) {
                    self.selectedCategory = category
                }
            }
    }
    
    func getPlanetsByCategory() -> [Planet] {
        homeViewModel.getPlanetsByCategory(category: selectedCategory, keyword: searchText)
    }
}

#Preview {
    NavigationStack {
        PlanetListContentView(homeViewModel: HomeViewModel(), showAddNewPlanetSheet: .constant(false))
    }
}
