//
//  TextOverlayView.swift
//  PlanetsApp
//
//  Created by rescalon on 20/4/24.
//

import SwiftUI

struct TextOverlayView: View {
    
    let title: String
    let caption: String?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .bold()
                if let caption {
                    Text(caption)
                        .font(.callout)
                        .lineLimit(1)
                }
            }
            .padding()
            .padding(.bottom, 24)
        }
        .foregroundStyle(.white)
    }
    
    var gradient: LinearGradient {
        .linearGradient(
            colors: [.black.opacity(0.7),
                     .black.opacity(0)
                    ],
            startPoint: .bottom,
            endPoint: .center
        )
    }
}

#Preview {
    TextOverlayView(title: "Earth", caption: "Small text")
}
