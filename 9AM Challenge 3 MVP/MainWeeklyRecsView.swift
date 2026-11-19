//
//  MainWeeklyRecsView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//


import SwiftUI

struct WeeklyRecsView: View {

    @AppStorage("preferredLocation")
    private var preferredLocation = "Anywhere"

    @State private var selectedRestaurant: Restaurant?

    private var region: RestaurantRegion {
        RestaurantRegion.from(preference: preferredLocation)
    }

    private var restaurants: [Restaurant] {
        RestaurantDirectory.weeklyPicks(for: region)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                Text("Weekly Recommendations")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(
                    region.isAnywhere
                        ? "Handpicked by Munchkin, just for you!"
                        : "Handpicked by Munchkin for the \(region.rawValue) region!"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)

                RegionFilterBar(selection: $preferredLocation)

                if restaurants.isEmpty {
                    ContentUnavailableView(
                        "No picks for \(region.rawValue) yet",
                        systemImage: "fork.knife",
                        description: Text("Try another region or choose Anywhere.")
                    )
                }

                ForEach(restaurants) { restaurant in
                    Button {
                        selectedRestaurant = restaurant
                    } label: {
                        RestaurantCard(restaurant: restaurant)
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
                restaurant: restaurant,
                reason: restaurant.recommendationReason
            )
        }
    }
}

#Preview {
    NavigationStack {
        WeeklyRecsView()
    }
}
