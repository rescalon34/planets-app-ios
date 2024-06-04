//
//  HomeViewModel.swift
//  PlanetsApp
//
//  Created by rescalon on 24/3/24.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    @Published var planets: [Planet] = []
    private(set) var previewPlanets: [Planet] = PlanetDataSource.load("PlanetData.json")
    var planetCategories : [String] = PlanetCategory.allCases.map { $0.category }
    var planetCardSegments : [String] = PlanetCardSegments.allCases.map { $0.option }
    @Published var isLoading : Bool = false
    @Published var carouselCounter = 0
    var carouselTimer: AnyCancellable?
    
    init() {
        loadPlanetsData { planetList in
            self.isLoading = false
            print("planets data: \(String(describing: planetList?.first))")
            self.planets = planetList ?? []
        }
    }
    
    /*
     Load Planet's data from a json file.
     */
    private func loadData() -> [Planet] {
        PlanetDataSource.load("PlanetData.json")
    }
    
    /*
     Ideally, this data should come from the API Network.
     We can call the @escaping return type directly too: onCompleted: @escaping ([Planet]?) -> ().
     */
    func loadPlanetsData(onCompleted: @escaping PlanetsDataCompletion) {
        isLoading = true
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.5) {
            let planetList = self.loadData()
            
            // change to the main thread to update UI after onCompleted callback.
            DispatchQueue.main.async {
                onCompleted(planetList)
            }
        }
    }
    
    func getPlanetsByCategory(category: String?, keyword: String? = nil) -> [Planet] {
        print("planet category: \(category ?? "")")
        
        if let keyword = keyword, !keyword.isEmpty {
            return planets.filter { $0.name.contains(keyword) }
        }
        
        guard let category = category else {
            return planets
        }
        
        return planets.filter { $0.category == category }
    }
    
    func getFavoritePlanets() -> [Planet] {
        planets.filter { $0.isFavorite }
    }
    
    /**
     * Get all favorite planets if segmented option is equals to Favorites, otherwise get all planets.
     */
    func getCardPlanets(selectedOption: String) -> [Planet] {
        if selectedOption == PlanetCardSegments.Favorites.option {
            return planets.filter { $0.isFavorite == true }
        }
        
        return planets
    }
    
    func getPlanetSharingInfo(planet: Planet) -> String {
        "Planet: \(planet.name), \(planet.overview)"
    }
    
    func arePlanesForThisCategory(category: String) -> Bool {
        !getPlanetsByCategory(category: category).isEmpty
    }
    
    func toggleFavoriteItem(planet: Planet) {
        if let index = planets.firstIndex(where: { $0.id == planet.id }) {
            planets[index] = planet.favoritePlanet()
        }
    }
    
    func addNewPlanet(planet: Planet) {
        planets.insert(planet, at: 0)
    }
    
    func removePlanet(planet: Planet) {
        if let index = planets.firstIndex(where: { $0.id == planet.id }) {
            planets.remove(at: index)
        }
    }
    
    func sharePlanet(text: String) {
        // TODO, handle logic to share image.
    }
    
    func movePlanet(fromOffsets: IndexSet, toOffset: Int) {
        planets.move(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    func setupCarouselTimer() {
        carouselTimer = Timer
            .publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] output in
                guard let self = self else { return }
                print("featured carousel timer: \(carouselCounter)")
                self.carouselCounter = getCarouselCounter()
            })
    }
    
    func cancelCaouselTimer() {
        carouselTimer?.cancel()
    }
    
    func getCarouselCounter() -> Int {
        carouselCounter == getFavoritePlanets().endIndex ? getFavoritePlanets().startIndex : carouselCounter + 1
    }
    
    // Planets completion type alias
    typealias PlanetsDataCompletion = ([Planet]?) -> ()
}
