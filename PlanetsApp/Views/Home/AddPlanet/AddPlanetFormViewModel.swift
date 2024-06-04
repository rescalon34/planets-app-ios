//
//  PlanetFormViewModel.swift
//  PlanetsApp
//
//  Created by rescalon on 25/3/24.
//

import Foundation
import Combine

class AddPlanetFormViewModel : ObservableObject {
    
    @Published var planetName: String = ""
    @Published var overview: String = ""
    @Published var description: String = ""
    @Published var naturalSatellites: Int = 0
    @Published var isFavorite: Bool = false
    @Published var selectedCategory: String?
    @Published var isValidFormFields = false
    var cancellables = Set<AnyCancellable>()
    @Published var formFields : [String] = []
    
    init() {
        formValidationSubscriber()
    }
    
    func getNewPlanet() -> Planet {
        let planet = Planet(
            name: planetName,
            imageName: nil,
            imageUrl: "https://science.nasa.gov/wp-content/uploads/2023/07/planet_9_art_1_1400.jpg?w=1400",
            overview: overview,
            description: description,
            isFavorite: isFavorite,
            category: selectedCategory ?? "",
            satellites: naturalSatellites
        )
        print("form data: ", planet)
        return planet
    }
    
    func isValidForm() -> Bool {
       return !planetName.isEmpty &&
        !overview.isEmpty &&
        !description.isEmpty &&
        selectedCategory != nil
    }
    
    /*
     This function is intended to validate if the given paramters are not empty using combine.
     If the values are not empty, the isValidFormFields variable will be true, as a result the
     "Done" button from the form screen will be enabled.
     */
    func formValidationSubscriber() {
        $planetName
            .combineLatest($overview, $description, $selectedCategory)
            .sink { [weak self] (planetName, overview, description, selectedCategory) in
                guard let self = self else { return }
                print("planetName: \(planetName)")
                print("overview: \(overview)")
                print("description: \(description)")
                
                self.isValidFormFields = !planetName.isEmpty &&
                !overview.isEmpty &&
                !description.isEmpty &&
                selectedCategory != nil
            }
            .store(in: &cancellables)
    }
    
    func hasChangesToDiscard() -> Bool {
        return !planetName.isEmpty || 
        !overview.isEmpty || 
        !description.isEmpty ||
        selectedCategory != nil
    }
}
