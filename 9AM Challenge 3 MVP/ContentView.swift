//
//  ContentView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView() {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            
            Tab("Munchie Mixer", systemImage: "mug.fill") {
                MunchieMixerView()
            }
            
            Tab("Shop", systemImage: "bag.fill") {
                ShopView()
            }
        }
    }
}

#Preview {
    ContentView()
}
