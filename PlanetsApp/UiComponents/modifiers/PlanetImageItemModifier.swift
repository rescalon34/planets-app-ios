//
//  PlanetImageItemModifier.swift
//  PlanetsApp
//
//  Created by rescalon on 28/3/24.
//

import SwiftUI

struct PlanetImageItemModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 70, height: 70)
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
