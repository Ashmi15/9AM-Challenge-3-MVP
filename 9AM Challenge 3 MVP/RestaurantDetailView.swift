//
//  RestaurantDetailView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//



import SwiftUI

struct RestaurantDetailView: View {

    let restaurant: Restaurant

    // User feedback
    @State private var hasVisited = false
    @State private var rating = 0
    @State private var selectedFlavours: Set<String> = []
    @State private var writtenReview = ""

    @State private var showConfirmation = false

    // Kept here so the detail screen can show Munchkin's dietary check too.
    @AppStorage("dietVegetarian") private var vegetarian = false
    @AppStorage("dietVegan") private var vegan = false
    @AppStorage("dietHalal") private var halal = false
    @AppStorage("dietGlutenFree") private var glutenFree = false
    @AppStorage("dietDairyFree") private var dairyFree = false

    private var diet: DietaryPreferences {
        DietaryPreferences(
            vegetarian: vegetarian,
            vegan: vegan,
            halal: halal,
            glutenFree: glutenFree,
            dairyFree: dairyFree
        )
    }

    let flavours = [
        "🌶️ Spicy",
        "🍜 Savoury",
        "🍰 Sweet",
        "🍲 Comforting",
        "🍋 Tangy",
        "🥗 Fresh"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {

                // MARK: Restaurant photo
                Text(restaurant.emoji)
                    .font(.system(size: 110))
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                // MARK: Restaurant name
                VStack(alignment: .leading, spacing: 8) {
                    Text(restaurant.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(restaurant.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    MunchkinDietMessage(
                        adherence: restaurant.dietAdherence(for: diet)
                    )
                }

                Divider()

                // MARK: Restaurant information
                VStack(alignment: .leading, spacing: 15) {

                    Text("Restaurant Information")
                        .font(.title2)
                        .fontWeight(.bold)

                    Label(
                        "Location: \(restaurant.locationLine)",
                        systemImage: "mappin.circle.fill"
                    )

                    Label(
                        "Cuisine: \(restaurant.cuisine)",
                        systemImage: "fork.knife"
                    )

                    Label(
                        "Region: \(restaurant.region.rawValue)",
                        systemImage: "map.circle.fill"
                    )

                    if !restaurant.phone.isEmpty {
                        Label(
                            "Phone: \(restaurant.phone)",
                            systemImage: "phone.circle.fill"
                        )
                    }

                    if let websiteURL = restaurant.websiteURL {
                        Link(destination: websiteURL) {
                            Label("Website", systemImage: "globe")
                        }
                    }
                }

                Divider()

                // MARK: Menu
                VStack(alignment: .leading, spacing: 12) {
                    Text("Menu Highlights 🍽️")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("🍜 Signature Dish")
                    Text("🥟 Chef's Special")
                    Text("🥤 House Drink")
                }

                Divider()

                // MARK: Visited status
                VStack(alignment: .leading, spacing: 15) {
                    Text("Have you visited?")
                        .font(.title2)
                        .fontWeight(.bold)

                    Button {
                        let wasVisited = hasVisited
                        hasVisited.toggle()
                        if hasVisited && !wasVisited {
                            incrementRestaurantGoal()
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: hasVisited ? "checkmark.square.fill" : "square")
                                .font(.title2)
                                .foregroundStyle(hasVisited ? .orange : .secondary)
                            Text("I've eaten here!")
                                .foregroundStyle(.primary)
                        }
                    }
                    .buttonStyle(.plain)
                }

                // Only show feedback if visited
                if hasVisited {
                    reviewSection
                }
            }
            .padding(20)
        }
        .background(
            Color(red: 1.0, green: 0.97, blue: 0.93)
        )
        .navigationTitle("Restaurant Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Review Saved! \(MunchkinPet.emoji)",
            isPresented: $showConfirmation
        ) {
            Button("Yay!", role: .cancel) {}
        } message: {
            Text("Munchkin will use your feedback to improve future recommendations!")
        }
    }

    // MARK: - Review Section

    var reviewSection: some View {
        VStack(alignment: .leading, spacing: 22) {

            Divider()

            Text("Help Munchkin Learn! \(MunchkinPet.emoji)")
                .font(.title2)
                .fontWeight(.bold)

            Text("Tell Munchkin what you thought so it can recommend better restaurants next time!")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Star rating
            VStack(alignment: .leading, spacing: 12) {
                Text("How much did you enjoy it?")
                    .font(.headline)

                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { star in
                        Button {
                            rating = star
                        } label: {
                            Image(
                                systemName: star <= rating
                                    ? "star.fill"
                                    : "star"
                            )
                            .font(.system(size: 30))
                            .foregroundStyle(.orange)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // Flavour preferences
            VStack(alignment: .leading, spacing: 12) {
                Text("What flavours did you enjoy?")
                    .font(.headline)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 10
                ) {
                    ForEach(flavours, id: \.self) { flavour in
                        Button {
                            if selectedFlavours.contains(flavour) {
                                selectedFlavours.remove(flavour)
                            } else {
                                selectedFlavours.insert(flavour)
                            }
                        } label: {
                            Text(flavour)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(
                                    selectedFlavours.contains(flavour)
                                        ? Color.orange.opacity(0.3)
                                        : Color.white
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 12)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // Written review
            VStack(alignment: .leading, spacing: 12) {
                Text("Anything else Munchkin should know?")
                    .font(.headline)

                TextEditor(text: $writtenReview)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
            }

            // Save button
            Button {
                saveReview()
            } label: {
                Text("Save My Review \(MunchkinPet.emoji)")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        rating > 0 ? Color.orange : Color.gray
                    )
                    .foregroundStyle(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
            }
            .disabled(rating == 0)
        }
    }

    // MARK: - Save Feedback

    func incrementRestaurantGoal() {
        let keyGoals = "goals_v1"

        var goals: [GoalItem] = []
        if let data = UserDefaults.standard.data(forKey: keyGoals),
           let decoded = try? JSONDecoder().decode([GoalItem].self, from: data) {
            goals = decoded
        }

        guard let idx = goals.firstIndex(where: { g in
            g.completedAt == nil && GoalKeywords.isFoodRelated(g.title)
        }) else { return }

        goals[idx].progress += 1
        if goals[idx].progress >= goals[idx].target {
            goals[idx].progress = goals[idx].target
            goals[idx].completedAt = Date()
            // Explicitly mark the reward as unclaimed. Completed goals with a
            // nil flag are treated as legacy by the Goals screen, so a fresh
            // completion must say "not paid yet" rather than leaving it unset.
            goals[idx].rewardClaimed = false
        }

        if let gData = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(gData, forKey: keyGoals)
        }
    }

    func saveReview() {
        let review = RestaurantReviewData(
            restaurantName: restaurant.name,
            rating: rating,
            flavours: Array(selectedFlavours),
            comment: writtenReview
        )

        if let encoded = try? JSONEncoder().encode(review) {
            UserDefaults.standard.set(
                encoded,
                forKey: "review_\(restaurant.name)"
            )
            // Ratings and feedback drive the food persona.
            _ = FoodPersonaStore.resolve(force: true)
            showConfirmation = true
        }
    }
}

// MARK: - Review Data Model

struct RestaurantReviewData: Codable {
    let restaurantName: String
    let rating: Int
    let flavours: [String]
    let comment: String
    let date: Date

    init(
        restaurantName: String,
        rating: Int,
        flavours: [String],
        comment: String,
        date: Date = Date()
    ) {
        self.restaurantName = restaurantName
        self.rating = rating
        self.flavours = flavours
        self.comment = comment
        self.date = date
    }

    /// Reviews saved before the date field existed still load correctly.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantName = try container.decode(String.self, forKey: .restaurantName)
        rating = try container.decode(Int.self, forKey: .rating)
        flavours = try container.decode([String].self, forKey: .flavours)
        comment = try container.decode(String.self, forKey: .comment)
        date = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
    }
}

#Preview {
    NavigationStack {
        RestaurantDetailView(restaurant: .preview)
    }
}
