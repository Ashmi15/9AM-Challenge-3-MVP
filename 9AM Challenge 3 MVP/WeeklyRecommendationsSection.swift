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
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("This Week's Top Recs 🍴")
                    .font(.headline)

                Spacer()

                Button("View All") {
                    // We'll connect this later.
                }
                .font(.subheadline)
                .foregroundStyle(.orange)
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

#Preview {
    WeeklyRecommendationsSection()
}
