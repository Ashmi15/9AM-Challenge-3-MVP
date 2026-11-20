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

    @AppStorage("preferredPersona") private var preferredPersona = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("goal_currency_v1") private var coins = 0

    @State private var personaSnapshot = FoodPersonaStore.resolve()
    @State private var showPetPicker = false

    private var diet: DietaryPreferences {
        DietaryPreferences(
            vegetarian: vegetarian,
            vegan: vegan,
            halal: halal,
            glutenFree: glutenFree,
            dairyFree: dairyFree
        )
    }

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

                    // MARK: Food Persona (changes with your reviews)
                    HStack(spacing: 15) {
                        Text(personaSnapshot.persona.emoji)
                            .font(.system(size: 65))
                            .frame(width: 95, height: 95)
                            .background(personaSnapshot.persona.accent)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("My Food Persona")
                                    .font(.headline)

                                Spacer()

                                Text("\(personaSnapshot.reviewCount) \(personaSnapshot.reviewCount == 1 ? "rating" : "ratings")")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Text(personaSnapshot.persona.name)
                                .font(.title3)
                                .fontWeight(.bold)

                            Text(personaSnapshot.persona.tagline)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(personaSnapshot.explanation)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .italic()
                        }
                    }
                    .padding(20)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    // MARK: Pet + tutorial controls
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Munchkin")
                            .font(.headline)

                        HStack(spacing: 12) {
                            Text(personaSnapshot.persona.emoji)
                                .font(.system(size: 38))

                            VStack(alignment: .leading, spacing: 3) {
                                Text(preferredPersona.isEmpty
                                     ? "Matching my reviews"
                                     : personaSnapshot.persona.name)
                                    .font(.subheadline.weight(.semibold))

                                Text(preferredPersona.isEmpty
                                     ? "My ratings and reviews pick the pet."
                                     : "Starting pet for now — my reviews take over next.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }

                        HStack(spacing: 10) {
                            Button {
                                showPetPicker = true
                            } label: {
                                Label("Change my pet", systemImage: "pawprint.fill")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.orange.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)

                            Button {
                                hasCompletedOnboarding = false
                            } label: {
                                Label("Replay tutorial", systemImage: "book.fill")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.teal.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // MARK: Shop (moved here from its own tab)
                    NavigationLink {
                        ShopView()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "bag.fill")
                                .font(.title2)
                                .foregroundStyle(.orange)
                                .frame(width: 38)

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Munchkin Shop")
                                    .font(.headline)

                                Text("Dress up your pet with the coins you earn.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("💰 \(coins)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.orange)

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(20)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(.plain)

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

                            HStack(alignment: .bottom, spacing: 8) {
                                Text(diet.summaryMessage)
                                    .font(.caption)
                                    .padding(10)
                                    .background(Color.mint.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))

                                Text(MunchkinPet.emoji)
                                    .font(.system(size: 32))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                        Text(MunchkinPet.emoji)
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
            .onAppear { personaSnapshot = FoodPersonaStore.resolve() }
            .onChange(of: preferredPersona) { _, _ in
                personaSnapshot = FoodPersonaStore.resolve(force: true)
            }
            .navigationTitle("My Munchkin Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showPetPicker) {
                NavigationStack {
                    PetPickerView(selection: $preferredPersona)
                        .navigationTitle("Choose your Munchkin")
                        .toolbar {
                            Button("Done") { showPetPicker = false }
                        }
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    ProfileView()
}

