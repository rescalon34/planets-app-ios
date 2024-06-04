//
//  CustomUnavailableContentView.swift
//  PlanetsApp
//
//  Created by rescalon on 30/4/24.
//

import SwiftUI

struct CustomUnavailableContentView<Content: View>: View {
    let image: String
    let title: String
    let description : String
    let ctaContent: () -> Content
    
    var body: some View {
        emptyContent
    }
    
    // MARK: - Views.
    @ViewBuilder
    private var emptyContent : some View {
        VStack(alignment: .center) {
            Image(image)
            Text(title)
                .font(.title)
            Text(description)
                .padding()
                .font(.title3)
                .multilineTextAlignment(.center)

            ctaContent()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    CustomUnavailableContentView(
        image: "empty_planet",
        title: "No planets",
        description: "There are no planets for this category yet.",
        ctaContent: {
            Button("Click me") {
                
            }
            .buttonStyle(.borderedProminent)
        }
    )
}
