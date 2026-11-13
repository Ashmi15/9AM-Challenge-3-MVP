//
//  WeeklyRecommendationsSection.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct WeeklyRecommendationsSection: View {
    let restaurants = [
        ("🍜", "Mala Hotpot", "Spicy • Chinatown"),
        ("🍣", "Sushi Corner", "Japanese • Orchard"),
        ("🍛", "Curry House", "Indian • Little India")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Top Weekly Recommendations")
                    .font(.headline)

                Spacer()

                NavigationLink(destination: WeeklyRecsView()) {
                    HStack(spacing: 4) {
                        Text("View All")

                        Image(systemName: "arrow.right")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                }
            }

            ForEach(restaurants, id: \.1) { restaurant in
                RestaurantCard(
                    emoji: restaurant.0,
                    name: restaurant.1,
                    description: restaurant.2
                )
            }
        }
    }
}


