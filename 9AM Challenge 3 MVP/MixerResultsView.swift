//
//  MixerResultsView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//


import SwiftUI

struct MixerResultsView: View {

    let selectedCravings: [String]

    @AppStorage("preferredLocation")
    private var preferredLocation = "Anywhere"

    private var region: RestaurantRegion {
        RestaurantRegion.from(preference: preferredLocation)
    }

    // Restaurants matching the selected cravings in the chosen region
    private var matchedRestaurants: [Restaurant] {
        RestaurantDirectory.recommendations(
            for: selectedCravings,
            region: region
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Your Munchie Matches! 🐱")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Based on your cravings: \(selectedCravings.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                RegionFilterBar(selection: $preferredLocation)

                if matchedRestaurants.isEmpty {
                    ContentUnavailableView(
                        region.isAnywhere
                            ? "No matches yet!"
                            : "No matches in \(region.rawValue)!",
                        systemImage: "fork.knife",
                        description: Text(
                            region.isAnywhere
                                ? "Try a different craving combination."
                                : "Try another region or a different craving combination."
                        )
                    )
                }

                ForEach(matchedRestaurants) { restaurant in

                    VStack(alignment: .leading, spacing: 12) {

                        NavigationLink {
                            RestaurantDetailView(restaurant: restaurant)
                        } label: {
                            RestaurantCard(restaurant: restaurant)
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
    }

    func explanation(for restaurant: Restaurant) -> String {
        let matches = restaurant.matchingCravings(selectedCravings)

        guard !matches.isEmpty else {
            return "I picked \(restaurant.name) because it's a great spot for your cravings!"
        }

        return "I picked \(restaurant.name) because it matches your \(joinedList(matches)) cravings!"
    }

    private func joinedList(_ items: [String]) -> String {
        let lowercased = items.map { $0.lowercased() }

        guard let last = lowercased.last else { return "" }
        guard lowercased.count > 1 else { return last }

        return lowercased.dropLast().joined(separator: ", ") + " and " + last
    }
}

#Preview {
    NavigationStack {
        MixerResultsView(
            selectedCravings: ["Spicy", "Savoury"]
        )
    }
}
