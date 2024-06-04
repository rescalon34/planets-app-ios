//
//  CustomConfirmationView.swift
//  PlanetsApp
//
//  Created by rescalon on 13/4/24.
//

import SwiftUI

struct CustomConfirmationView: View {
    let planetName: String
    
    var body: some View {
        messageContentView
    }
    
    var messageContentView : some View {
        Label("You've favorited \(planetName)", systemImage: "checkmark.circle.fill")
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.green)
            )
    }
}

#Preview {
    CustomConfirmationView(planetName: "Mars")
        .padding()
}
