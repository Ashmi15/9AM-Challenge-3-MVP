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

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("goal_currency_v1") private var coins = 0

    @State private var personaSnapshot = FoodPersonaStore.resolve()

    private var diet: DietaryPreferences {
        DietaryPreferences(
            vegetarian: vegetarian,
            vegan: vegan,
            halal: halal
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
                        .font(.dynaPuff(15))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // MARK: Food Persona (changes with your reviews)
                    HStack(spacing: 15) {
                        MunchkinAvatarView(persona: personaSnapshot.persona, size: 65)
                            .frame(width: 120, height: 120)
                            .background(personaSnapshot.persona.accent)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("My Food Persona")
                                    .font(.dynaPuff(17))

                                Spacer()

                                Text("\(personaSnapshot.reviewCount) \(personaSnapshot.reviewCount == 1 ? "rating" : "ratings")")
                                    .font(.dynaPuff(13))
                                    .foregroundStyle(.secondary)
                            }

                            Text(personaSnapshot.persona.name)
                                .font(.dynaPuff(20))
                                .fontWeight(.bold)

                            Text(personaSnapshot.persona.tagline)
                                .font(.dynaPuff(13))
                                .foregroundStyle(.secondary)

                            Text(personaSnapshot.explanation)
                                .font(.dynaPuff(13))
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
                            .font(.dynaPuff(17))

                        HStack(spacing: 12) {
                            MunchkinAvatarView(persona: personaSnapshot.persona, size: 38)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(personaSnapshot.persona.name)
                                    .font(.dynaPuff(15).weight(.semibold))

                                Text("Changes automatically as I rate places.")
                                    .font(.dynaPuff(13))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }

                        HStack(spacing: 10) {
                            Button {
                                hasCompletedOnboarding = false
                            } label: {
                                Label("Replay tutorial", systemImage: "book.fill")
                                    .font(.dynaPuff(13).weight(.semibold))
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
                                .font(.dynaPuff(22))
                                .foregroundStyle(.orange)
                                .frame(width: 38)

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Munchkin Shop")
                                    .font(.dynaPuff(17))

                                Text("Dress up your pet with the coins you earn.")
                                    .font(.dynaPuff(13))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("💰 \(coins)")
                                .font(.dynaPuff(15).weight(.semibold))
                                .foregroundStyle(.orange)

                            Image(systemName: "chevron.right")
                                .font(.dynaPuff(13))
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
                            .font(.dynaPuff(22))
                            .fontWeight(.bold)

                        // Location
                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "Preferred Location",
                                systemImage: "mappin.circle.fill"
                            )
                            .font(.dynaPuff(17))

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
                                .font(.dynaPuff(13))
                                .foregroundStyle(.secondary)
                        }

                        Divider()

                        // Budget
                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "Budget per Person",
                                systemImage: "dollarsign.circle.fill"
                            )
                            .font(.dynaPuff(17))

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
                            .font(.dynaPuff(17))

                            Toggle("Vegetarian", isOn: $vegetarian)
                            Toggle("Vegan", isOn: $vegan)
                            Toggle("Halal-certified", isOn: $halal)

                            if halal {
                                Text("Only restaurants in the directory that are halal will be shown.")
                                    .font(.dynaPuff(12))
                                    .foregroundStyle(.secondary)
                            }

                            HStack(alignment: .bottom, spacing: 8) {
                                Text(diet.summaryMessage)
                                    .font(.dynaPuff(13))
                                    .padding(10)
                                    .background(Color.mint.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))

                                MunchkinAvatarView(persona: personaSnapshot.persona, size: 32)
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
                        MunchkinAvatarView(persona: personaSnapshot.persona, size: 40)

                        Text("The better I know your tastes, the yummier your recommendations!")
                            .font(.dynaPuff(15))
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
            .navigationTitle("My Munchkin Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView()
}

