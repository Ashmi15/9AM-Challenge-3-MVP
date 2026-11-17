//
//  HomeView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

private struct HomeGoalItem: Codable, Identifiable {
    var id: UUID
    var title: String
    var target: Int
    var progress: Int
    var difficulty: String?
    var completedAt: Date?
    var rewardClaimed: Bool?
}

struct HomeView: View {
    @State private var activeGoals: [HomeGoalItem] = []
    @State private var currency = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    // Welcome
                    HStack {
                        VStack() {
                            Text("Hello Munchkin!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .overlay(alignment: .trailing) {
                                    Text("🪙 \(currency)")
                                        .font(.headline)
                                        .foregroundStyle(.orange)
                                }

                            Text("Are you ready for your next food adventure?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .bold()
                                .multilineTextAlignment(.center)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Your Current Food Persona")
                                    .font(.headline)
                                HStack(spacing: 15) {
                                    Text("🐶")
                                        .font(.system(size: 65))
                                    
                                    VStack(alignment:.leading, spacing: 6) {
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
                            
                            VStack(alignment: .leading, spacing: 5) {
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
                                        ForEach(Array(activeGoals.prefix(2))) { g in
                                            GoalProgressRow(
                                                title: g.title,
                                                progress: g.progress,
                                                total: g.target,
                                                completed: g.completedAt != nil,
                                                reward: GoalReward.coins(for: g.difficulty ?? "Easy"),
                                                onClaim: g.completedAt != nil ? { claimReward(g) } : nil
                                            )
                                        }
                                    }
                                }
                                .padding(20)
                                .frame(width: 375)
                                .frame(minHeight: 150)
                                .background(Color(red: 0.65, green: 0.89, blue: 0.75))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            
                            WeeklyRecommendationsSection()
                                .padding(20)
                                .background(Color(red: 0.35, green: 0.79, blue: 0.75))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(width: 375, height: 305)
                        }
                        
                    }
                    
                    
                    
                }
                .onAppear(perform: loadGoals)
            }
        }
    }

    func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: "goals_v1"),
           let decoded = try? JSONDecoder().decode([HomeGoalItem].self, from: data) {
            // Keep completed goals visible until their reward has been claimed.
            activeGoals = decoded.filter { $0.rewardClaimed != true }
        } else {
            activeGoals = []
        }

        currency = UserDefaults.standard.integer(forKey: "goal_currency_v1")
    }

    private func claimReward(_ goal: HomeGoalItem) {
        var goals: [GoalItem] = []
        if let data = UserDefaults.standard.data(forKey: "goals_v1"),
           let decoded = try? JSONDecoder().decode([GoalItem].self, from: data) {
            goals = decoded
        }

        guard let index = goals.firstIndex(where: { $0.id == goal.id }),
              goals[index].completedAt != nil,
              goals[index].rewardClaimed != true else { return }

        let reward = GoalReward.coins(for: goals[index].difficulty)
        goals[index].rewardClaimed = true

        var history: [CompletedGoalRecord] = []
        if let data = UserDefaults.standard.data(forKey: "goal_history_v1"),
           let decoded = try? JSONDecoder().decode([CompletedGoalRecord].self, from: data) {
            history = decoded
        }
        history.append(CompletedGoalRecord(
            title: goals[index].title,
            difficulty: goals[index].difficulty,
            reward: reward,
            completedAt: goals[index].completedAt ?? Date()
        ))

        let currency = UserDefaults.standard.integer(forKey: "goal_currency_v1") + reward
        UserDefaults.standard.set(currency, forKey: "goal_currency_v1")
        self.currency = currency
        if let data = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(data, forKey: "goals_v1")
        }
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: "goal_history_v1")
        }

        activeGoals.removeAll { $0.id == goal.id }
    }
}


#Preview {
    HomeView()
}
