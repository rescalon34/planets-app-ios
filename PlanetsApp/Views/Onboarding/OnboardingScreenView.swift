//
//  OnboardingScreenView.swift
//  PlanetsApp
//
//  Created by rescalon on 24/4/24.
//

import SwiftUI

struct OnboardingScreenView: View {
    private var viewModel: OnboardingViewModel = OnboardingViewModel()
    @State var selectedScreen = 1
    @AppStorage(AppStorageConstants.onboardingCompletedKey) var isOnboardingCompleted: Bool = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView(
                colors: getBackgroundColorsById(id: selectedScreen),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            onboardingContent
        }
        .onAppear {
            viewModel.setupOnboardingData()
        }
    }
    
    // MARK: - Views.
    var onboardingContent: some View {
        VStack {
            onboardingTabView
            Spacer()
            makeOnboardingCtaButton(selectedScreen: selectedScreen)
        }
    }
    
    var onboardingTabView : some View {
        TabView(selection: $selectedScreen) {
            ForEach(viewModel.onboardingImages) { item in
                makeOnboardingContent(onboardingItem: item)
            }
        }
        .tag(selectedScreen)
        .tabViewStyle(.page)
        .padding(.bottom)
        
        .onChange(of: selectedScreen, initial: true) { oldValue, newValue in
            withAnimation(.easeInOut.delay(1)) {
                selectedScreen = newValue
            }
        }
    }
    
    // MARK: - View functions.
    private func makeOnboardingContent(onboardingItem: OnboardingItem) -> some View {
        VStack {
            ZStack {
                Circle()
                    .background(.ultraThinMaterial)
                    .frame(width: 308, height: 308)
                    .clipShape(Circle())
                    .shadow(color: .white, radius: 12)
                
                Image(onboardingItem.image)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            }
            makeCardInfoView(title: onboardingItem.title, description: onboardingItem.description)
        }
    }
    
    private func makeCardInfoView(title: String, description: String) -> some View {
        VStack {
            Text(title)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
            Text(description)
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 2)
        }
        .padding()
    }
    
    @ViewBuilder
    private func makeOnboardingCtaButton(selectedScreen: Int) -> some View {
        let ctaText: String = {
            switch selectedScreen {
            case 1, 2: return "Next"
            default: return "Finish Onboarding"
            }
        }()
        
        Button(action: {
            handleCtaClickAction(selectedScreen: selectedScreen)
        }, label: {
            Text(ctaText)
                .padding(.all, 16)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .buttonBorderShape(.capsule)
                .padding(.horizontal, 32)
        })
    }
    
    // MARK: - UI logic Views.
    private func getBackgroundColorsById(id: Int) -> [Color] {
        switch id {
        case 1:
            return [.purple, .indigo, .pink]
        case 2:
            return [.purple, .blue, .teal]
        default:
            return [.cyan.opacity(0.6), .green, .cyan]
        }
    }
    
    // Depending on the screen, navigate to next onboarding content or to the home screen
    // after tapping on the finish button.
    // TODO: set App Storage flag to finish onboarding and don't show it again.
    private func handleCtaClickAction(selectedScreen: Int) {
        if selectedScreen == 3 {
            withAnimation(.easeOut) {
                isOnboardingCompleted.toggle()
            }
        } else {
            withAnimation(.easeInOut(duration: 1)) {
                self.selectedScreen += 1
            }
        }
    }
}

#Preview {
    OnboardingScreenView()
}
