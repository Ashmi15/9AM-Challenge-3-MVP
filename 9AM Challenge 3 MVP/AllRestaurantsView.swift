//
//  AllRestaurantsView.swift
//  9AM Challenge 3 MVP
//
//  A browsable tab containing the full restaurant directory.
//

import SwiftUI

struct AllRestaurantsView: View {
    @AppStorage("preferredLocation") private var preferredLocation = "Anywhere"
    @AppStorage("dietVegetarian") private var vegetarian = false
    @AppStorage("dietVegan") private var vegan = false
    @AppStorage("dietHalal") private var halal = false
    @AppStorage("dietGlutenFree") private var glutenFree = false
    @AppStorage("dietDairyFree") private var dairyFree = false

    @State private var searchText = ""
    @State private var onlyDietMatches = true

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
        var list = RestaurantDirectory.all

        if !region.isAnywhere {
            list = list.filter { $0.region == region }
        }

        if !diet.isEmpty && onlyDietMatches {
            list = RestaurantDirectory.matchingDiet(list, using: diet)
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            list = list.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(query)
                    || restaurant.cuisine.localizedCaseInsensitiveContains(query)
                    || restaurant.area.localizedCaseInsensitiveContains(query)
            }
        }

        return list
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("Search name, cuisine or area", text: $searchText)
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Clear search")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )

                RegionFilterBar(selection: $preferredLocation)

                if !diet.isEmpty {
                    Toggle("Only spots matching all my dietary needs", isOn: $onlyDietMatches)
                        .font(.subheadline)
                        .tint(.teal)
                        .padding(.horizontal, 4)
                }

                Text("\(restaurants.count) \(restaurants.count == 1 ? "restaurant" : "restaurants")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if restaurants.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty
                            ? "No restaurants found"
                            : "No results for \"\(searchText)\"",
                        systemImage: searchText.isEmpty ? "fork.knife" : "magnifyingglass",
                        description: Text(
                            searchText.isEmpty
                                ? "Try another region or turn off the diet filter."
                                : "Try a different name, cuisine or area."
                        )
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(restaurants) { restaurant in
                                NavigationLink {
                                    RestaurantDetailView(restaurant: restaurant)
                                } label: {
                                    RestaurantCard(restaurant: restaurant)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.bottom, 12)
                    }
                }
            }
            .padding()
            .background(Color(red: 1.0, green: 0.97, blue: 0.93))
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    AllRestaurantsView()
}
