//
//  OnboardingViewModel.swift
//  PlanetsApp
//
//  Created by rescalon on 26/4/24.
//

import Foundation

class OnboardingViewModel {
    
   private(set) var onboardingImages : [OnboardingItem] = []
    
    init() {
        setupOnboardingData()
    }
    
    func setupOnboardingData() {
        onboardingImages = [
            OnboardingItem(
                id: 1,
                image: "milkyway",
                title: "A Milky Way view",
                description: "Look, here is where you make your dreams come true.",
                ctaButtonText: "Next"
            ),
            OnboardingItem(
                id: 2,
                image: "nebulosa",
                title: "Brigth and luminescent dots",
                description: "Far far away from Earth is where these giant clouds are shinning.",
                ctaButtonText: "Next"
            ),
            OnboardingItem(
                id: 3,
                image: "apod3",
                title: "Amazing views taken from Earth",
                description: "Delightful moments with sunset and milky way together.",
                ctaButtonText: "Finish Onboarding"
            ),
        ]
    }
}
