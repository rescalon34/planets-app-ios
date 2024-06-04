//
//  CategoryCapsuleView.swift
//  PlanetsApp
//
//  Created by rescalon on 7/4/24.
//

import SwiftUI

struct CategoryCapsuleView: View {
    let isSelected: Bool
    let categoryName: String
    
    var body: some View {
        categoryCapsule
    }
    
    var categoryCapsule: some View {
        Text(categoryName)
            .font(.callout)
            .bold()
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(isSelected ? .indigo : .white)
                    .stroke(isSelected ? .indigo : .gray, lineWidth: 1)
            )
    }
}

#Preview {
    CategoryCapsuleView(isSelected: true, categoryName: "Popular")
}
