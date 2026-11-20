//
//  MunchieMixerView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//


import SwiftUI

struct MunchieMixerView: View {

    // Cravings available to select
    let cravings: [(name: String, emoji: String)] = [
        ("Spicy", "🌶️"),
        ("Sweet", "🍰"),
        ("Salty", "🧂"),
        ("Tangy", "🍋"),
        ("Savoury", "🍜"),
        ("Comforting", "🍲")
    ]

    @State private var selectedCravings: Set<String> = []
    @State private var showResults = false

    @Namespace private var mixingAnimation

    private let backgroundColor = Color(
        red: 1.0,
        green: 0.97,
        blue: 0.93
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {

                    // MARK: Subtitle
                    Text("Mix your cravings, find your munch!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // MARK: Mascot
                    HStack(spacing: 15) {
                        MunchkinAvatarView(size: 70)

                        Text("What would you like to eat today?")
                            .font(.headline)
                            .padding(15)
                            .background(Color.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 20)
                            )
                    }

                    // MARK: Craving Selection
                    Text("Choose your cravings!")
                        .font(.title3)
                        .fontWeight(.bold)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 18
                    ) {
                        ForEach(cravings, id: \.name) { craving in

                            let isSelected =
                                selectedCravings.contains(craving.name)

                            Button {
                                withAnimation(.spring(
                                    response: 0.5,
                                    dampingFraction: 0.7
                                )) {
                                    if isSelected {
                                        selectedCravings.remove(craving.name)
                                    } else {
                                        selectedCravings.insert(craving.name)
                                    }
                                }
                            } label: {
                                VStack(spacing: 8) {

                                    if !isSelected {
                                        Text(craving.emoji)
                                            .font(.system(size: 45))
                                            .matchedGeometryEffect(
                                                id: craving.name,
                                                in: mixingAnimation
                                            )
                                    } else {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 45))
                                            .foregroundStyle(.orange)
                                    }

                                    Text(craving.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(
                                    isSelected
                                        ? Color.orange.opacity(0.2)
                                        : Color.white
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 20)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // MARK: Mixing Bowl
                    VStack(spacing: 10) {

                        Text("Your Mixing Bowl")
                            .font(.title3)
                            .fontWeight(.bold)

                        ZStack {

                            // Bowl
                            Ellipse()
                                .fill(Color.orange.opacity(0.3))
                                .frame(width: 300, height: 100)

                            Ellipse()
                                .stroke(Color.orange, lineWidth: 5)
                                .frame(width: 300, height: 100)

                            // Ingredients inside the bowl
                            HStack(spacing: 8) {
                                ForEach(
                                    cravings.filter {
                                        selectedCravings.contains($0.name)
                                    },
                                    id: \.name
                                ) { craving in

                                    Text(craving.emoji)
                                        .font(.system(size: 35))
                                        .matchedGeometryEffect(
                                            id: craving.name,
                                            in: mixingAnimation
                                        )
                                }
                            }
                        }
                        .frame(height: 150)

                        Text(
                            selectedCravings.isEmpty
                            ? "Your bowl is empty!"
                            : "\(selectedCravings.count) cravings added!"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    // MARK: Mix Button
                    Button {
                        showResults = true
                    } label: {
                        Text("Mix My Cravings! 🥄")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                selectedCravings.isEmpty
                                    ? Color.gray
                                    : Color.orange
                            )
                            .foregroundStyle(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 18)
                            )
                    }
                    .disabled(selectedCravings.isEmpty)

                }
                .padding(20)
            }
            .background(backgroundColor)
            .navigationTitle("The Munchie Mixer!")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showResults) {
                MixerResultsView(
                    selectedCravings: Array(selectedCravings).sorted()
                )
            }
        }
    }
}

#Preview {
    MunchieMixerView()
}
