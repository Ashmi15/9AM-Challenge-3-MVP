//
//  HomeView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct HomeView: View {
    @State private var activeGoals: [GoalItem] = []
    @State private var claimableGoals: [GoalItem] = []
    @State private var currency = 0
    @State private var personaSnapshot = FoodPersonaStore.resolve()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Are you ready for your next food adventure?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .frame(width: 375, alignment: .leading)

                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Your Food Persona")
                                .font(.headline)

                            Spacer()

                            Text("\(personaSnapshot.reviewCount) \(personaSnapshot.reviewCount == 1 ? "rating" : "ratings")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        HStack(spacing: 15) {
                            MunchkinAvatarView(persona: personaSnapshot.persona, size: 65)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(personaSnapshot.persona.name)
                                    .font(.title3)
                                    .fontWeight(.bold)

                                Text(personaSnapshot.persona.tagline)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Text(personaSnapshot.explanation)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .italic()
                            }

                            Spacer()
                        }
                    }
                    .padding(20)
                    .frame(width: 375)
                    .background(personaSnapshot.persona.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Goals Left For This Month")
                            .font(.headline)

                        if activeGoals.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "target")
                                    .font(.title2)
                                    .foregroundStyle(.green)

                                Text("No active goals.\nSet some in the Goals tab.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, minHeight: 70)
                        } else {
                            ForEach(activeGoals) { goal in
                                GoalProgressRow(
                                    title: goal.title,
                                    progress: goal.progress,
                                    total: goal.target
                                )
                            }
                        }

                        if !claimableGoals.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Ready to Claim", systemImage: "gift.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.green)

                                ForEach(claimableGoals) { goal in
                                    Button {
                                        claimReward(goal.id)
                                    } label: {
                                        HStack(spacing: 8) {
                                            Text(goal.title)
                                                .font(.caption)
                                                .lineLimit(1)

                                            Spacer(minLength: 6)

                                            Text("Claim +💰\(GoalReward.coins(for: goal.difficulty))")
                                                .font(.caption.weight(.bold))
                                                .foregroundStyle(.green)
                                        }
                                        .padding(.vertical, 9)
                                        .padding(.horizontal, 12)
                                        .background(Color.green.opacity(0.14))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel("Claim reward for \(goal.title)")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(20)
                    .frame(width: 375)
                    .background(Color(red: 0.90, green: 0.89, blue: 0.97))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    WeeklyRecommendationsSection()
                        .padding(20)
                        .background(Color(red: 1.0, green: 0.93, blue: 0.79))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 375)
                }
                .onAppear {
                    loadGoals()
                    personaSnapshot = FoodPersonaStore.resolve()
                }
            }
            .navigationTitle("Hello Munchkin!")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("💰 \(currency)")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
            }
        }
    }

    private func loadGoals() {
        let savedGoals = UserDefaults.standard.data(forKey: "goals_v1")
            .flatMap { try? JSONDecoder().decode([GoalItem].self, from: $0) } ?? []

        activeGoals = savedGoals.filter { $0.completedAt == nil }
        claimableGoals = savedGoals.filter {
            $0.completedAt != nil && $0.rewardClaimed != true
        }

        currency = UserDefaults.standard.integer(forKey: "goal_currency_v1")
    }

    private func claimReward(_ id: UUID) {
        GoalClaim.claim(id)
        loadGoals()
    }
}

#Preview {
    HomeView()
}
