//
//  OnboardingData.swift
//  PlanetsApp
//
//  Created by rescalon on 26/4/24.
//

import Foundation

struct OnboardingItem: Identifiable {
    let id: Int
    let image: String
    let title: String
    let description: String
    let ctaButtonText: String
}
