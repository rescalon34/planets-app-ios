//
//  ProfileScreenView.swift
//  PlanetsApp
//
//  Created by rescalon on 27/4/24.
//

import SwiftUI

struct ProfileScreenView: View {
    @AppStorage(AppStorageConstants.onboardingCompletedKey) var isOnboardingCompleted: Bool = false
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            List {
                profileHeader
                profileOptions
                profilePhotos
            }
            .listStyle(.insetGrouped)
            .onAppear {
                viewModel.getAllSavedImages()
            }
        }
        .background()
        .navigationTitle("Profile")
    }
}

// MARK: - ExtensionViews
extension ProfileScreenView {
    var profileHeader : some View {
        VStack {
            profileImage
            profileOverview
        }
        .frame(maxWidth: .infinity)
    }
    
    var profileImage : some View {
        Image("apod3")
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(Circle())
    }
    
    var profileOverview : some View {
        Button("Edit profile") {
            // TODO
        }
        .padding(.vertical)
    }
    
    var profileOptions: some View {
        Section("Preferences") {
            Toggle("Reset onboarding", isOn: $isOnboardingCompleted)
        }
    }
    
    @ViewBuilder
    var profilePhotos : some View {
        Section("Saved images") {
            VStack {
                HStack {
                    Spacer()
                    Button("See All") {
                        // TODO
                    }
                }
                if viewModel.profileImages.isEmpty {
                    ProgressView()
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.profileImages, id: \.self) { imageUrl in
                                getSquaredProfileImage(imageUrl: imageUrl)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func getSquaredProfileImage(imageUrl: String) -> some View {
        VStack {
            if let uiImage = UIImage(contentsOfFile: imageUrl) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .planetImageItemModifier()
            } else {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

#Preview {
    ProfileScreenView()
}
