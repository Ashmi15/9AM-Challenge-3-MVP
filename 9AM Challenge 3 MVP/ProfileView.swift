//
//  ProfileView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//


import SwiftUI

struct ProfileView: View {

    // Preferences saved locally on the device
    @AppStorage("preferredLocation")
    private var preferredLocation = "Anywhere"

    @AppStorage("preferredBudget")
    private var preferredBudget = "$10–$25"

    @AppStorage("dietVegetarian")
    private var vegetarian = false

    @AppStorage("dietVegan")
    private var vegan = false

    @AppStorage("dietHalal")
    private var halal = false

    @AppStorage("dietGlutenFree")
    private var glutenFree = false

    @AppStorage("dietDairyFree")
    private var dairyFree = false

    private let locations = [
        "Anywhere",
        "North",
        "South",
        "East",
        "West",
        "Central"
    ]

    private let budgets = [
        "Under $10",
        "$10–$25",
        "$25–$50",
        "$50+"
    ]

    private let backgroundColor = Color(
        red: 0.95,
        green: 0.98,
        blue: 0.96
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {

                    // MARK: Profile Header
                    Text("Your food adventure, your rules!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // MARK: Food Persona
                    HStack(spacing: 15) {
                        Text("🐱")
                            .font(.system(size: 65))
                            .frame(width: 95, height: 95)
                            .background(Color.mint.opacity(0.2))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 6) {
                            Text("My Food Persona")
                                .font(.headline)

                            Text("The Spice Explorer 🌶️")
                                .font(.title3)
                                .fontWeight(.bold)

                            Text("Bold, adventurous and always hungry!")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(20)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    // MARK: Preferences
                    VStack(alignment: .leading, spacing: 20) {

                        Text("My Preferences")
                            .font(.title2)
                            .fontWeight(.bold)

                        // Location
                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "Preferred Location",
                                systemImage: "mappin.circle.fill"
                            )
                            .font(.headline)

                            Picker(
                                "Location",
                                selection: $preferredLocation
                            ) {
                                ForEach(locations, id: \.self) { location in
                                    Text(location).tag(location)
                                }
                            }
                            .tint(.teal)

                            Text("Your weekly picks and Munchie Mixer results will focus on this region.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Divider()

                        // Budget
                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "Budget per Person",
                                systemImage: "dollarsign.circle.fill"
                            )
                            .font(.headline)

                            Picker(
                                "Budget",
                                selection: $preferredBudget
                            ) {
                                ForEach(budgets, id: \.self) { budget in
                                    Text(budget).tag(budget)
                                }
                            }
                            .tint(.teal)
                        }

                        Divider()

                        // Diet
                        VStack(alignment: .leading, spacing: 14) {
                            Label(
                                "Dietary Preferences",
                                systemImage: "leaf.fill"
                            )
                            .font(.headline)

                            Toggle("Vegetarian", isOn: $vegetarian)
                            Toggle("Vegan", isOn: $vegan)
                            Toggle("Halal-friendly", isOn: $halal)
                            Toggle("Gluten-free", isOn: $glutenFree)
                            Toggle("Dairy-free", isOn: $dairyFree)
                        }
                        .tint(.teal)

                    }
                    .padding(20)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    // MARK: Mascot Message
                    HStack(spacing: 12) {
                        Text("🐱")
                            .font(.system(size: 40))

                        Text("The better I know your tastes, the yummier your recommendations!")
                            .font(.subheadline)
                            .foregroundStyle(
                                Color(red: 0.2, green: 0.45, blue: 0.35)
                            )

                        Spacer()
                    }
                    .padding(18)
                    .background(Color.mint.opacity(0.2))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
                }
                .padding(20)
            }
            .background(backgroundColor)
            .navigationTitle("My Munchkin Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView()
}

