//
//  ContentView.swift
//  PlanetsApp
//
//  Created by rescalon on 24/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab : Tab = .Home
    
    enum Tab {
        case Home
        case Posts
        case Profile
    }
    
    var body: some View {
        mainTabView
    }
    
    // MARK: - It contains all the main Bottom screens in a TabView.
    var mainTabView : some View {
        TabView(selection: $selectedTab) {
            HomeScreenView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.Home)
            
            PostScreenView()
                .tabItem {
                    Label("Posts", systemImage: "newspaper.fill")
                }
                .tag(Tab.Posts)
            
            NavigationStack {
                ProfileScreenView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
            .tag(Tab.Profile)
        }
    }
}

#Preview {
    ContentView()
}
