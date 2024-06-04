//
//  SplashScreenView.swift
//  PlanetsApp
//
//  Created by rescalon on 23/4/24.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isSplashFinished: Bool
    
    var body: some View {
        splashContent
            .onAppear {
                onSplashFinish()
            }
    }
    
    // MARK: - Views.
    var splashContent : some View {
        ZStack {
            // background color.
            GradientBackgroundView(
                colors: [.indigo, .cyan],
                startPoint: .topLeading,
                endPoint: .trailing
            )
            
            VStack {
                Image("rocket")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Text("A planet's Journey!")
                    .padding(.top)
            }
            .font(.title2)
            .foregroundStyle(.white)
        }
    }
    
    // MARK: - Functions.
    // show Splash for 2.5 seconds, then show the navigate to the screen.
    private func onSplashFinish() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut) {
                isSplashFinished.toggle()
            }
        }
    }
}

#Preview {
    SplashScreenView(isSplashFinished: .constant(false))
}
