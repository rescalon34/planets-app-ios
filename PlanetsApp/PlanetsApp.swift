//
//  PlanetsApp.swift
//  PlanetsApp
//
//  Created by rescalon on 24/3/24.
//

import SwiftUI

@main
struct PlanetsApp: App {
    @AppStorage(AppStorageConstants.onboardingCompletedKey) var isOnboardingCompleted : Bool = false
    @State var isPlashFinished: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !isPlashFinished {
                SplashScreenView(isSplashFinished: $isPlashFinished)
            } else {
                showNextDestinationScreen()
            }
        }
    }
    
    private func showNextDestinationScreen() -> some View {
        if !isOnboardingCompleted {
             return AnyView(OnboardingScreenView())
        } else {
             return AnyView(ContentView())
        }
    }
}
