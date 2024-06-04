//
//  BaseSheetModalView.swift
//  PlanetsApp
//
//  Created by rescalon on 10/5/24.
//

import SwiftUI

/*
 BaseSheetModalView, intended to show a reusable sheet content whenever a button is tapped.
 @See the HomeScreenView for reference on how to use it.
 */
struct BaseSheetModalView<Content: View>: View, Identifiable {
    let id: Int = UUID().hashValue
    let content: () -> Content
    
      var body: some View {
        content()
      }
}

#Preview {
    BaseSheetModalView {
        Text("Add sheet content")
    }
}
