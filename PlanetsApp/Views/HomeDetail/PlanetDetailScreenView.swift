//
//  PlanetDetailScreenView.swift
//  PlanetsApp
//
//  Created by rescalon on 24/3/24.
//

import SwiftUI
import Combine

struct PlanetDetailScreenView: View {
    var planet: Planet
    @StateObject var homeViewModel : HomeViewModel
    @StateObject var planetDetailViewModel = PlanetDetailViewModel()
    @State var descriptionTitle = "Description"
    @State var shouldAnimate = false
    @State var showConfirmationMessage = false
    @State var showConfirmationDialog : Bool = false
    @State var animateFavoriteButton : Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var currentGestureValue : CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack {
                headerImage
                headerOverview
                PlanetDescription(descriptionTitle: $descriptionTitle, description: planet.description)
            }
            .navigationBarTitle(planet.name, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    moreOptionsButton
                }
            }
            .onAppear(perform: {
                shouldAnimate = planet.isFavorite
            })
            .onReceive(Just(planetDetailViewModel.isImageSaved)) { saved in
                if saved {
                    presentationMode.wrappedValue.dismiss()
                }
            }
//            .onReceive(planetDetailViewModel.onImageSaved) { saved in
//                // go back to home once the image is saved.
//                if saved {
//                    presentationMode.wrappedValue.dismiss()
//                }
//            }
            Spacer()
        }
        .onAppear(perform: animateFavoriteHeartButton)
        .confirmationDialog("What do you want to do?", isPresented: $showConfirmationDialog, titleVisibility: .visible, actions: getConfirmationDialogActions)
        
        if showConfirmationMessage {
            CustomConfirmationView(planetName: planet.name)
                .transition(.move(edge: .bottom))
                .padding(.top, 4)
                .padding(.horizontal)
        }
    }
    
    // MARK: - Views
    @ViewBuilder
    var headerImage : some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: planet.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(1 + currentGestureValue)
                    .overlay(alignment: .bottomLeading) {
                        TextOverlay(planet: planet)
                            .opacity(currentGestureValue > 0 ? 0.0 : 1.0)
                    }
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.easeOut) {
                                    currentGestureValue = getMagnificationGestureValue(value: value)
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring) {
                                    currentGestureValue = 0
                                }
                            }
                    )
                    .onAppear {
                        planetDetailViewModel.setSaveImageData(image: image, imageName: planet.name)
                    }
            } placeholder: {
                ZStack {
                    ProgressView()
                }
                .frame(idealWidth: .infinity, idealHeight: 300, alignment: .center)
            }
        }
        .zIndex(1.0)
    }
    
    // Overview description below image
    var headerOverview : some View {
        HStack {
            VStack(alignment: .leading) {
                Label(
                    title: { Text("Moons: \(planet.satellites ?? 0)") },
                    icon: { Image(systemName: "moon.fill") }
                )
                .labelStyle(.titleAndIcon)
                .font(.callout)
            }
            Spacer()
            favoriteButton.padding()
        }
        .padding()
    }
    
    /**
     Double tap to favorita a planet.
     */
    var favoriteButton : some View {
        CircleFavoriteButton(isFavorite: planet.isFavorite, shouldAnimate: $shouldAnimate)
            .scaleEffect(animateFavoriteButton ? 1.2 : 1.0)
            .onTapGesture(count: 2, perform: {
                homeViewModel.toggleFavoriteItem(planet: planet)
                withAnimation(.spring) {
                    shouldAnimate.toggle()
                    
                    if !planet.isFavorite {
                        showConfirmationMessage.toggle()
                        onDismissCustomView()
                    }
                }
            })
    }
    
    var moreOptionsButton : some View {
        Button {
            showConfirmationDialog.toggle()
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    // Description
    var planetDescription : some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.title2)
                .fontWeight(.medium)
            Text(planet.description)
                .padding(.top, 1)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    // Description using Binding and State sample.
    struct PlanetDescription : View {
        @Binding var descriptionTitle: String
        let description : String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(descriptionTitle)
                    .font(.title2)
                    .fontWeight(.medium)
                Text(description)
                    .padding(.top, 1)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
    
    // MARK: - SubViews.
    struct TextOverlay : View {
        let planet: Planet
        
        var gradient: LinearGradient {
            .linearGradient(
                colors: [.black.opacity(0.75),
                         .black.opacity(0)
                ],
                startPoint: .bottom,
                endPoint: .center
            )
        }
        
        var body: some View {
            ZStack(alignment: .bottomLeading) {
                gradient
                VStack(alignment: .leading) {
                    Text(planet.name)
                        .font(.largeTitle)
                        .bold()
                    Text(planet.overview)
                        .font(.title2)
                        .lineLimit(2)
                }
                .textSelection(.enabled)
                .padding()
            }
            .foregroundStyle(.white)
        }
    }
    
    // MARK: - Dismiss custom message view after delay
    func onDismissCustomView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeOut) {
                showConfirmationMessage = false
            }
        }
    }
    
    func animateFavoriteHeartButton() {
        guard !animateFavoriteButton && !planet.isFavorite else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                .easeInOut(duration: 1.2)
                .repeatForever()
            ) {
                animateFavoriteButton.toggle()
            }
        }
    }
    
    @ViewBuilder
    func getConfirmationDialogActions() -> some View {
        Button("Save Image", role: .none) {
            planetDetailViewModel.savePlanetImage()
        }
        // TODO, share image.
        ShareLink(item: homeViewModel.getPlanetSharingInfo(planet: planet)) {
            Text("Share")
        }
        Button("Remove Planet", role: .destructive) {
            homeViewModel.removePlanet(planet: planet)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    let homeViewModel = HomeViewModel()
    return PlanetDetailScreenView(
        planet: homeViewModel.previewPlanets[1],
        homeViewModel: HomeViewModel()
    )
}
