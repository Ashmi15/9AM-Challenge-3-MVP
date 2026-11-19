//
//  HomeView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct HomeView: View {
    @State private var activeGoals: [GoalItem] = []
    @State private var completedGoalsAwaitingClaim = 0
    @State private var currency = 0

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
                        Text("Your Current Food Persona")
                            .font(.headline)

                        HStack(spacing: 15) {
                            Text("🐶")
                                .font(.system(size: 65))

                            VStack(alignment: .leading, spacing: 6) {
                                Text("The Comfort Foodie")
                                    .font(.title3)
                                    .fontWeight(.bold)

                                Text("Like Cookie the puppy, lying on the couch while eating a tub of ice cream from Yo-Chi is your thing!")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .bold()
                            }

                            Spacer()
                        }
                    }
                    .padding(20)
                    .frame(width: 375, height: 205)
                    .background(Color(red: 0.95, green: 0.75, blue: 0.73))
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

                        if completedGoalsAwaitingClaim > 0 {
                            Label(
                                completedGoalsAwaitingClaim == 1
                                    ? "1 completed goal is waiting! Claim your coins in the Goals tab."
                                    : "\(completedGoalsAwaitingClaim) completed goals are waiting! Claim your coins in the Goals tab.",
                                systemImage: "gift.fill"
                            )
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.green)
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
                        .frame(width: 375, height: 305)
                }
                .onAppear(perform: loadGoals)
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
        completedGoalsAwaitingClaim = savedGoals.filter {
            $0.completedAt != nil && $0.rewardClaimed != true
        }.count

        currency = UserDefaults.standard.integer(forKey: "goal_currency_v1")
    }
}

#Preview {
    HomeView()
}
