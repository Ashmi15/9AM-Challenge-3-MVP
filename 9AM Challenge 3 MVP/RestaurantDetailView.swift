//
//  RestaurantDetailView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//



import SwiftUI

struct RestaurantDetailView: View {

    let emoji: String
    let name: String
    let description: String

    // User feedback
    @State private var hasVisited = false
    @State private var rating = 0
    @State private var selectedFlavours: Set<String> = []
    @State private var writtenReview = ""

    @State private var showConfirmation = false

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
                Text(emoji)
                    .font(.system(size: 110))
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                // MARK: Restaurant name
                VStack(alignment: .leading, spacing: 8) {
                    Text(name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // MARK: Restaurant information
                VStack(alignment: .leading, spacing: 15) {

                    Text("Restaurant Information")
                        .font(.title2)
                        .fontWeight(.bold)

                    Label(
                        "Location: \(description)",
                        systemImage: "mappin.circle.fill"
                    )

                    Label(
                        "Budget: $10–$25 per person",
                        systemImage: "dollarsign.circle.fill"
                    )

                    Label(
                        "Cuisine: Asian",
                        systemImage: "fork.knife"
                    )
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

                    Toggle(
                        "I've eaten here!",
                        isOn: $hasVisited
                    )
                    .tint(.orange)
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
            "Review Saved! 🐱",
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

            Text("Help Munchkin Learn! 🐱")
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
                Text("Save My Review 🐱")
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

    func saveReview() {
        let review = RestaurantReviewData(
            restaurantName: name,
            rating: rating,
            flavours: Array(selectedFlavours),
            comment: writtenReview
        )

        if let encoded = try? JSONEncoder().encode(review) {
            UserDefaults.standard.set(
                encoded,
                forKey: "review_\(name)"
            )
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
}

#Preview {
    NavigationStack {
        RestaurantDetailView(
            emoji: "🍜",
            name: "Mala Hotpot",
            description: "Spicy • Chinatown"
        )
    }
}
