//
//  GradientBackgroundView.swift
//  PlanetsApp
//
//  Created by rescalon on 26/4/24.
//

import SwiftUI

struct GradientBackgroundView: View {
    let colors : [Color]
    let startPoint: UnitPoint, endPoint: UnitPoint
    
    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .ignoresSafeArea()
    }
}

#Preview {
    GradientBackgroundView(colors: [.pink, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
}
