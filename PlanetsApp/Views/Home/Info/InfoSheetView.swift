//
//  InfoScreenView.swift
//  PlanetsApp
//
//  Created by rescalon on 2/6/24.
//

import SwiftUI

struct InfoSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            infoViewContent
            dismissButton
        }
        .padding()
    }
    
    var infoViewContent : some View {
        VStack {
            Text("Info")
                .font(.title)
            Text("Info sheet view to demonstrate the usage of reusable sheet behavior using a BaseSheetModalView approach.")
                .padding()
                .font(.body)
            Image("apod3")
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .scaledToFit()
                .blur(radius: 2.0)
                .cornerRadius(20)
            Spacer()
        }
    }
    
    var dismissButton : some View {
        Text("Dismiss view")
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.indigo)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }
}

#Preview {
    InfoSheetView()
}
