//
//  AddPlanetSheetView.swift
//  PlanetsApp
//
//  Created by rescalon on 25/3/24.
//

import SwiftUI

struct AddPlanetSheetView: View {
    @ObservedObject var homeViewModel : HomeViewModel
    @StateObject var addPlanetFormViewModel = AddPlanetFormViewModel()
    @State var showFormAlert : Bool = false
    @State var alertType: AlertType? = nil
    @Environment(\.presentationMode) var presentationMode
    
    enum AlertType {
        case Discard
        case Validation
    }
    
    var body: some View {
        NavigationStack {
            AddPlanetFormView(addPlanetFormViewModel: addPlanetFormViewModel, categories: homeViewModel.planetCategories)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            onCancelDialogAction()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Add Planet")
                            .font(.title2)
                            .bold()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            savePlanet()
                        }
                        .disabled(!addPlanetFormViewModel.isValidFormFields)
                    }
                }
                .toolbarTitleDisplayMode(.inline)
                .alert(isPresented: $showFormAlert, content: getAlertMessage)
        }
    }
    
    func onCancelDialogAction() {
        if addPlanetFormViewModel.hasChangesToDiscard() {
            alertType = .Discard
            showFormAlert.toggle()
        } else {
            dismissDialogSheet()
        }
    }
    
    /*
     Check if the form is valid before saving the new planet, if it's not valid
     show an alert dialog.
     */
    func savePlanetOnFormValid() {
        if addPlanetFormViewModel.isValidForm() {
            homeViewModel.addNewPlanet(planet: addPlanetFormViewModel.getNewPlanet())
            dismissDialogSheet()
        } else {
            alertType = .Validation
            showFormAlert.toggle()
        }
    }
    
    /*
     This function will save the new planet, if the button is enabled then we can save
     the data.
     */
    func savePlanet() {
        homeViewModel.addNewPlanet(planet: addPlanetFormViewModel.getNewPlanet())
        dismissDialogSheet()
    }
    
    
    func getAlertMessage() -> Alert {
        switch alertType {
        case .Validation:
            Alert(
                title: Text("Add planet info 🪐"),
                message: Text("You must add the required planet's info before trying to save it.")
            )
        default: Alert(
            title: Text("Discard Changes 😨"),
            message: Text("Do you want to leave without saving your data?"),
            primaryButton: .destructive(Text("Discard")) {
                dismissDialogSheet()
            },
            secondaryButton: .cancel()
            )
        }
    }
    
    func dismissDialogSheet() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationStack {
        AddPlanetSheetView(homeViewModel: HomeViewModel())
    }
}
