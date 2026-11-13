//
//  MainWeeklyRecsView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//


import SwiftUI

struct WeeklyRecsView: View {

    let restaurants = [
        ("🍜", "Mala Hotpot", "Spicy • Chinatown"),
        ("🍣", "Sushi Corner", "Japanese • Orchard"),
        ("🍛", "Curry House", "Indian • Little India"),
        ("🍕", "Pizza Paradise", "Italian • Bugis"),
        ("🥟", "Dumpling House", "Chinese • Tampines")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {

                Text("Weekly Recommendations")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Handpicked by Munchkin, just for you!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(restaurants, id: \.1) { restaurant in
                    RestaurantCard(
                        emoji: restaurant.0,
                        name: restaurant.1,
                        description: restaurant.2
                    )
                }
            }
            .padding(20)
        }
        .background(
            Color(red: 1.0, green: 0.97, blue: 0.93)
        )
    }
}

#Preview {
    NavigationStack {
        WeeklyRecsView()
    }
}
