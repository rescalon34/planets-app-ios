//
//  AddPlanetForm.swift
//  PlanetsApp
//
//  Created by rescalon on 25/3/24.
//

import SwiftUI

struct AddPlanetFormView: View {
    @ObservedObject var addPlanetFormViewModel : AddPlanetFormViewModel
    var categories: [String]
    
    var body: some View {
        VStack {
            Form {
                Section("DETAILS") {
                    TextField("Name", text: $addPlanetFormViewModel.planetName)
                    TextField("Overview", text: $addPlanetFormViewModel.overview)
                }
                Section("PREFERNCES") {
                    Toggle(isOn: $addPlanetFormViewModel.isFavorite, label: {
                        Text("Add to Favorites")
                    })
                    
                    Stepper("Satellites: \(addPlanetFormViewModel.naturalSatellites)",
                            value: $addPlanetFormViewModel.naturalSatellites,
                            in: 0...50,
                            step: 1
                    )
                    
                
                    Picker("Category", selection: $addPlanetFormViewModel.selectedCategory) {
                        Text("Select an option").tag(Optional<String>(nil))
                        ForEach(categories, id: \.self) {
                            Text($0).tag(Optional($0))
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section("Description") {
                    TextEditor(text: $addPlanetFormViewModel.description)
                        .lineLimit(4)
                        .frame(height: 100)
                }
            }
        }
    }
}

#Preview {
    AddPlanetFormView(
        addPlanetFormViewModel: AddPlanetFormViewModel(),
        categories: HomeViewModel().planetCategories
    )
}
