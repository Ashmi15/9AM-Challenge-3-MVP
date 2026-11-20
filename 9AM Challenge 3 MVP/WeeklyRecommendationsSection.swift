//
//  WeeklyRecommendationsSection.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct WeeklyRecommendationsSection: View {
    @AppStorage("preferredLocation")
    private var preferredLocation = "Anywhere"

    @AppStorage("dietVegetarian") private var vegetarian = false
    @AppStorage("dietVegan") private var vegan = false
    @AppStorage("dietHalal") private var halal = false
    @AppStorage("dietGlutenFree") private var glutenFree = false
    @AppStorage("dietDairyFree") private var dairyFree = false

    private var region: RestaurantRegion {
        RestaurantRegion.from(preference: preferredLocation)
    }

    private var diet: DietaryPreferences {
        DietaryPreferences(
            vegetarian: vegetarian,
            vegan: vegan,
            halal: halal,
            glutenFree: glutenFree,
            dairyFree: dairyFree
        )
    }

    private var restaurants: [Restaurant] {
        let picks = RestaurantDirectory.dietAwareWeeklyPicks(for: region, using: diet)
        return Array(picks.prefix(3))
    }

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

            HStack {
                Menu {
                    Picker("Region", selection: $preferredLocation) {
                        ForEach(RestaurantRegion.allCases) { region in
                            Text(region.rawValue).tag(region.rawValue)
                        }
                    }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "mappin.circle.fill")

                        Text(
                            region.isAnywhere
                                ? "All regions"
                                : "\(region.rawValue) region"
                        )

                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange.opacity(0.12))
                    .clipShape(Capsule())
                }
                .accessibilityLabel("Preferred region")

                Spacer()
            }

            if restaurants.isEmpty {
                Text(diet.isEmpty
                     ? "No picks in this region yet. Try another region."
                     : "No spots here match all your dietary needs. Try another region or relax a restriction.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 60)
            } else {
                ForEach(restaurants) { restaurant in
                    NavigationLink {
                        RestaurantDetailView(restaurant: restaurant)
                    } label: {
                        RestaurantCard(restaurant: restaurant)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
