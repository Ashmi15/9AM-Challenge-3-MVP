//
//  ContentView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage(AppAppearance.storageKey) private var appearanceMode = AppAppearance.device

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Explore", systemImage: "magnifyingglass") {
                AllRestaurantsView()
            }
            Tab("Goals", systemImage: "target") {
                GoalsView()
            }
            Tab("Munchie Mixer", systemImage: "mug.fill") {
                MunchieMixerView()
            }
            Tab("Profile", systemImage: "person.crop.circle.fill") {
                ProfileView()
            }
        }
        .preferredColorScheme(AppAppearance.colorScheme(for: appearanceMode))
        .fullScreenCover(
            isPresented: Binding(
                get: { !hasCompletedOnboarding },
                set: { hasCompletedOnboarding = !$0 }
            )
        ) {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
