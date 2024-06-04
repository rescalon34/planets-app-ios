//
//  PlanetCardsView.swift
//  PlanetsApp
//
//  Created by rescalon on 18/4/24.
//

import SwiftUI

struct PlanetCardsContentView: View {
    @ObservedObject var homeViewModel : HomeViewModel
    @State private var selectedCardSegment: String = PlanetCardSegments.All.option
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        
        // Segmented attributes
        let attributes : [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white
        ]
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.systemIndigo
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    var body: some View {
        segmentedCardView
        planetCards
    }
    
    // MARK: - Segmented CardView to switch between all/favorites planets.
    var segmentedCardView : some View {
        VStack {
            Picker("", selection: $selectedCardSegment) {
                ForEach(homeViewModel.planetCardSegments, id: \.self) { option in
                    Text(option)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
    }
    
    // MARK: - Main Card planets content
    var planetCards : some View {
        List {
            ForEach(homeViewModel.getCardPlanets(selectedOption: selectedCardSegment)) { planet in
                PlanetCardView(
                    planet: planet,
                    favoriteButtonContent: {
                        SimpleFavoriteView(isFavorite: planet.isFavorite)
                            .padding()
                            .gesture(TapGesture().onEnded {
                                withAnimation(.smooth) {
                                    homeViewModel.toggleFavoriteItem(planet: planet)
                                }
                            }
                            )
                    }
                )
                .background(
                    NavigationLink("", destination: PlanetDetailScreenView(planet: planet, homeViewModel: homeViewModel))
                        .buttonStyle(PlainButtonStyle())
                        .opacity(0)
                )
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation {
                            homeViewModel.removePlanet(planet: planet)
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .onMove(perform: { indices, newOffset in
                homeViewModel.movePlanet(fromOffsets: indices, toOffset: newOffset)
            })
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    PlanetCardsContentView(homeViewModel: HomeViewModel())
}
