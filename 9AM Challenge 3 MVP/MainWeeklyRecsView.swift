//
//  MainWeeklyRecsView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//



import SwiftUI

struct WeeklyRecsView: View {

    @State private var selectedRestaurant: RestaurantPreview?

    let restaurants: [RestaurantPreview] = [
        RestaurantPreview(
            emoji: "🍜",
            name: "Mala Hotpot",
            description: "Spicy • Chinatown",
            reason: "You love bold, spicy flavours! This is right up your alley!"
        ),
        RestaurantPreview(
            emoji: "🍣",
            name: "Sushi Corner",
            description: "Japanese • Orchard",
            reason: "You enjoy savoury flavours, and Japanese food could be a great match!"
        ),
        RestaurantPreview(
            emoji: "🍛",
            name: "Curry House",
            description: "Indian • Little India",
            reason: "You've shown an interest in aromatic, spicy dishes!"
        ),
        RestaurantPreview(
            emoji: "🍕",
            name: "Pizza Paradise",
            description: "Italian • Bugis",
            reason: "Sometimes comforting, cheesy food is exactly what you need!"
        ),
        RestaurantPreview(
            emoji: "🥟",
            name: "Dumpling House",
            description: "Chinese • Tampines",
            reason: "These savoury dumplings match your love of comforting food!"
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {

                Text("Weekly Recommendations")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Handpicked by Munchkin, just for you!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(restaurants) { restaurant in
                    Button {
                        selectedRestaurant = restaurant
                    } label: {
                        RestaurantCard(
                            emoji: restaurant.emoji,
                            name: restaurant.name,
                            description: restaurant.description
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(
            Color(red: 1.0, green: 0.97, blue: 0.93)
        )

        // Opens the half-sheet
        .sheet(item: $selectedRestaurant) { restaurant in
            RestaurantPreviewSheet(
                emoji: restaurant.emoji,
                name: restaurant.name,
                description: restaurant.description,
                reason: restaurant.reason
            )
        }
    }
}

// Restaurant data model
struct RestaurantPreview: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let description: String
    let reason: String
}

#Preview {
    NavigationStack {
        WeeklyRecsView()
    }
}
