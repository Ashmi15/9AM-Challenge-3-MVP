//
//  MixerResultsView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//


import SwiftUI

struct MixerResultsView: View {

    let selectedCravings: [String]

    // Temporary recommendation data
    let restaurants: [(emoji: String, name: String, description: String, tags: [String])] = [
        ("🍜", "Mala Hotpot", "Spicy • Chinatown", ["Spicy", "Salty", "Savoury"]),
        ("🍣", "Sushi Corner", "Japanese • Orchard", ["Savoury", "Salty"]),
        ("🍛", "Curry House", "Indian • Little India", ["Spicy", "Comforting"]),
        ("🍕", "Pizza Paradise", "Italian • Bugis", ["Savoury", "Comforting"]),
        ("🥟", "Dumpling House", "Chinese • Tampines", ["Salty", "Comforting"]),
        ("🍰", "Dessert Cafe", "Desserts • Bugis", ["Sweet", "Tangy"])
    ]

    // Restaurants matching the selected cravings
    var matchedRestaurants: [(emoji: String, name: String, description: String, tags: [String])] {
        let ranked = restaurants
            .map { restaurant in
                (
                    restaurant: restaurant,
                    score: restaurant.tags.filter {
                        selectedCravings.contains($0)
                    }.count
                )
            }
            .filter { $0.score > 0 }
            .sorted {
                if $0.score != $1.score {
                    return $0.score > $1.score
                }
                return $0.restaurant.name < $1.restaurant.name
            }

        return Array(ranked.prefix(3).map { $0.restaurant })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Based on your cravings: \(selectedCravings.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if matchedRestaurants.isEmpty {
                    ContentUnavailableView(
                        "No matches yet!",
                        systemImage: "fork.knife",
                        description: Text("Try a different craving combination.")
                    )
                }

                ForEach(matchedRestaurants, id: \.name) { restaurant in

                    VStack(alignment: .leading, spacing: 12) {

                        NavigationLink {
                            RestaurantDetailView(
                                emoji: restaurant.emoji,
                                name: restaurant.name,
                                description: restaurant.description
                            )
                        } label: {
                            RestaurantCard(
                                emoji: restaurant.emoji,
                                name: restaurant.name,
                                description: restaurant.description
                            )
                        }
                        .buttonStyle(.plain)

                        HStack(alignment: .bottom, spacing: 10) {

                            Text(explanation(for: restaurant))
                                .font(.subheadline)
                                .padding(12)
                                .background(Color.orange.opacity(0.15))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15)
                                )

                            Text("🐱")
                                .font(.system(size: 40))
                        }
                    }
                    .padding(12)
                    .background(Color.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
                }
            }
            .padding(20)
        }
        .background(
            Color(red: 1.0, green: 0.97, blue: 0.93)
        )
        .navigationTitle("Your Munchie Matches! 🐱")
        .navigationBarTitleDisplayMode(.inline)
    }

    func explanation(
        for restaurant: (
            emoji: String,
            name: String,
            description: String,
            tags: [String]
        )
    ) -> String {

        let matches = restaurant.tags.filter {
            selectedCravings.contains($0)
        }

        return "I picked \(restaurant.name) because it matches your \(matches.joined(separator: " and ").lowercased()) cravings!"
    }
}

#Preview {
    NavigationStack {
        MixerResultsView(
            selectedCravings: ["Spicy", "Savoury"]
        )
    }
}
