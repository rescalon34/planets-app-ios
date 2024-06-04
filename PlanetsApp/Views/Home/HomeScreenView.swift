//
//  HomeScreenView.swift
//  PlanetsApp
//
//  Created by rescalon on 24/3/24.
//

import SwiftUI
import Combine

struct HomeScreenView: View {
    // MARK: - State Objects.
    @StateObject private var homeViewModel = HomeViewModel()
    
    // MARK: View Properties.
    @State private var showAddNewPlanetSheet: Bool = false
    @State private var contentViewType: HomeContentViewType = .List
    @State private var isEditableList: Bool = false
    @State private var selectedSheetView: BaseSheetModalView<AnyView>? = nil
    
    var body: some View {
        NavigationSplitView {
            ZStack {
                planetsContent
                    .navigationTitle("Planets")
                    .toolbar {
                        if isEditableMode() {
                            ToolbarItem(placement: .topBarLeading) {
                                EditButton()
                            }
                        }
                        ToolbarItem {
                            Button {
                                selectedSheetView = BaseSheetModalView {
                                    AnyView(InfoSheetView())
                                }
                            } label: {
                                Image(systemName: "info.circle")
                            }
                        }
                        ToolbarItem {
                            Button {
                                selectedSheetView = BaseSheetModalView {
                                    AnyView(AddPlanetSheetView(homeViewModel: homeViewModel))
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        ToolbarItem {
                            Button {
                                withAnimation {
                                    toggleViewType()
                                }
                            } label: {
                                Image(systemName: getToggleIcon())
                            }
                        }
                    }
                
                // using a BaseSheetModal approach to show a botton sheet.
                    .popover(item: $selectedSheetView) { selectedSheet in
                        selectedSheet.content()
                    }
            }
            .onReceive(Just(showAddNewPlanetSheet)) { showSheet in
                print("showSheet: \(showSheet)")
                if showSheet {
                    selectedSheetView = BaseSheetModalView {
                        AnyView(AddPlanetSheetView(homeViewModel: homeViewModel))
                    }
                }
                showAddNewPlanetSheet = false
            }
        } detail: {
            // load the first planet by default when launching the app on an ipad.
            if let selectedPlanet = homeViewModel.planets.first {
                PlanetDetailScreenView(planet: selectedPlanet, homeViewModel: homeViewModel)
            }
        }
    }
    
    // MARK: - Views.
    var planetsContent : some View {
        VStack {
            if !homeViewModel.planets.isEmpty {
                switch contentViewType {
                case .Grid:
                    PlanetGridContentView(homeViewModel: homeViewModel)
                case .List:
                    PlanetListContentView(
                        homeViewModel: homeViewModel,
                        showAddNewPlanetSheet: $showAddNewPlanetSheet
                    )
                case .Card:
                    PlanetCardsContentView(homeViewModel: homeViewModel)
                case .Featured:
                    PlanetFeaturedContentView(homeViewModel: homeViewModel)
                }
            } else {
                if homeViewModel.isLoading {
                    ProgressView()
                } else {
                    CustomUnavailableContentView(
                        image: "empty_planet",
                        title: "No planets",
                        description: "There are no planets for this category yet.",
                        ctaContent: {
                            Button("Add a planet") {
                                selectedSheetView = BaseSheetModalView {
                                    AnyView(AddPlanetSheetView(homeViewModel: homeViewModel))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.borderedProminent)
                            .font(.headline)
                        }
                    )
                    .padding()
                    .transition(.opacity.animation(.easeIn))
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Functions.
    private func toggleViewType() {
        let allCases = HomeContentViewType.allCases
        guard let currentIndex = allCases.firstIndex(of: contentViewType) else {
            return
        }
        
        let nextIndex = (currentIndex + 1) % allCases.count
        contentViewType = allCases[nextIndex]
    }
    
    private func isEditableMode() -> Bool {
        contentViewType != .Grid
    }
    
    private func getToggleIcon() -> String {
        switch contentViewType {
        case .Grid:
            "list.bullet"
        case .List:
            "list.bullet.rectangle"
        case .Card:
            "list.bullet.circle"
        case .Featured:
            "square.grid.2x2"
        }
    }
}

// MARK: - Preview.
#Preview {
    NavigationStack {
        HomeScreenView()
    }
}
