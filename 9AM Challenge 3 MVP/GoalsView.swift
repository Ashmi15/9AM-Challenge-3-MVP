import SwiftUI

struct GoalItem: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var target: Int
    var progress: Int
    var difficulty: String // Easy/Medium/Hard
    var createdAt: Date? = nil
    var completedAt: Date? = nil
    var rewardClaimed: Bool? = nil
}

struct CompletedGoalRecord: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var difficulty: String
    var reward: Int
    var completedAt: Date
}

enum GoalReward {
    static func coins(for difficulty: String) -> Int {
        switch difficulty {
        case "Easy": return 10
        case "Medium": return 25
        case "Hard": return 50
        default: return 10
        }
    }
}

// Detects whether a goal is about eating out / trying new food places.
enum GoalKeywords {
    private static let foodKeywords = [
        "restaurant", "cuisine", "spot", "place", "eat", "food",
        "dish", "meal", "cafe", "dining", "bakery", "dessert"
    ]

    static func isFoodRelated(_ title: String) -> Bool {
        let lowercased = title.lowercased()
        return foodKeywords.contains { lowercased.contains($0) }
    }
}

struct GoalsView: View {
    @State private var goals: [GoalItem] = []
    @State private var history: [CompletedGoalRecord] = []
    @State private var currency: Int = 0

    @State private var showAdd = false
    @State private var showClearHistory = false
    @State private var newTitle = ""
    @State private var newTarget = 1

    private let backgroundColor = Color(red: 1.0, green: 0.97, blue: 0.93)
    private let cardColor = Color.white

    private var activeGoals: [GoalItem] {
        // Keep completed goals visible until their reward has been claimed.
        goals.filter { $0.rewardClaimed != true }
    }

    private var sortedHistory: [CompletedGoalRecord] {
        history.sorted { $0.completedAt > $1.completedAt }
    }

    var body: some View {
        NavigationStack {
            List {
                // Header
                HStack(alignment: .firstTextBaseline) {
                    Text("Goals")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Text("💰 \(currency)")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
                .rowStyling(top: 12, bottom: 4)

                // Active goals
                Text("Active Goals")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .rowStyling(top: 12, bottom: 0)

                if activeGoals.isEmpty {
                    Text("No active goals. Add one below.")
                        .foregroundStyle(.secondary)
                        .rowStyling()
                } else {
                    ForEach(activeGoals) { g in
                        goalRow(g)
                            .rowStyling()
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteGoal(g.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }

                // Quick add
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick add")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Button("Try 3 new restaurants") { presetGoal(title: "Try 3 new restaurants", target: 3, difficulty: "Medium") }
                            Button("Explore 2 new cuisines") { presetGoal(title: "Explore 2 new cuisines", target: 2, difficulty: "Medium") }
                            Button("Visit 1 new spot") { presetGoal(title: "Visit 1 new spot", target: 1, difficulty: "Easy") }
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                    }
                }
                .rowStyling(top: 12)

                Button {
                    showAdd = true
                } label: {
                    Label("Add Custom Goal", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .rowStyling()

                Divider()
                    .rowStyling(top: 12, bottom: 4)

                // History
                HStack(alignment: .firstTextBaseline) {
                    Text("History")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Spacer()

                    if !history.isEmpty {
                        Button("Clear") {
                            showClearHistory = true
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.orange)
                    }
                }
                .rowStyling(top: 8, bottom: 0)

                if history.isEmpty {
                    Text("No completed goals yet.")
                        .foregroundStyle(.secondary)
                        .rowStyling()
                } else {
                    ForEach(sortedHistory) { h in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(h.title).fontWeight(.medium)
                                Text("\(h.difficulty) • \(h.completedAt.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("+💰\(h.reward)")
                                .fontWeight(.semibold)
                                .foregroundStyle(.orange)
                        }
                        .padding()
                        .background(cardColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .rowStyling()
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(backgroundColor)
            .navigationBarHidden(true)
            .onAppear(perform: load)
            .confirmationDialog(
                "Clear goal history?",
                isPresented: $showClearHistory,
                titleVisibility: .visible
            ) {
                Button("Clear History", role: .destructive) {
                    clearHistory()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This removes your completed goal records. Your coins and active goals stay as they are.")
            }
            .sheet(isPresented: $showAdd) {
                NavigationStack {
                    Form {
                        TextField("Goal title", text: $newTitle)
                        Stepper("Target: \(newTarget)", value: $newTarget, in: 1...50)

                        if GoalKeywords.isFoodRelated(newTitle) {
                            Label(
                                "This goal will update when you mark a restaurant as visited.",
                                systemImage: "fork.knife"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .navigationTitle("New Goal")
                    .tint(.orange)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showAdd = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                addGoal()
                                showAdd = false
                            }
                            .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        }
    }

    private func goalRow(_ g: GoalItem) -> some View {
        let isCompleted = g.completedAt != nil
        let isReadyToClaim = isCompleted && g.rewardClaimed != true

        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(g.title)
                    .fontWeight(.medium)
                    .lineLimit(1)

                if isCompleted {
                    Image(systemName: "flag.checkered")
                        .font(.caption)
                        .foregroundStyle(.green)
                }

                Spacer(minLength: 8)

                Text("\(g.progress)/\(g.target)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)

                Text(g.difficulty)
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

            ProgressView(value: Double(g.progress), total: Double(max(g.target, 1)))
                .tint(isCompleted ? .green : .orange)
                .frame(maxWidth: .infinity)

            if isReadyToClaim {
                Button {
                    claimReward(g.id)
                } label: {
                    Label("Claim +💰\(GoalReward.coins(for: g.difficulty))", systemImage: "gift.fill")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        .padding(14)
        .background(cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    func presetGoal(title: String, target: Int, difficulty: String) {
        goals.append(GoalItem(title: title, target: target, progress: 0, difficulty: difficulty))
        save()
    }

    func difficultyForTarget(_ target: Int) -> String {
        switch target {
        case ...1: return "Easy"
        case 2...3: return "Medium"
        default: return "Hard"
        }
    }

    func addGoal() {
        let t = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        goals.append(GoalItem(title: t, target: newTarget, progress: 0, difficulty: difficultyForTarget(newTarget)))
        newTitle = ""
        newTarget = 1
        save()
    }

    func deleteGoal(_ id: UUID) {
        goals.removeAll { $0.id == id }
        save()
    }

    func claimReward(_ id: UUID) {
        guard let index = goals.firstIndex(where: { $0.id == id }) else { return }
        guard goals[index].completedAt != nil, goals[index].rewardClaimed != true else { return }

        let reward = GoalReward.coins(for: goals[index].difficulty)
        currency += reward
        history.append(CompletedGoalRecord(
            title: goals[index].title,
            difficulty: goals[index].difficulty,
            reward: reward,
            completedAt: goals[index].completedAt ?? Date()
        ))
        goals[index].rewardClaimed = true
        save()
    }

    func load() {
        if let data = UserDefaults.standard.data(forKey: "goals_v1"),
           let decoded = try? JSONDecoder().decode([GoalItem].self, from: data) {
            goals = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "goal_history_v1"),
           let decoded = try? JSONDecoder().decode([CompletedGoalRecord].self, from: data) {
            history = decoded
        }
        currency = UserDefaults.standard.integer(forKey: "goal_currency_v1")

        // Goals completed before rewards became claimable were already paid out.
        // Mark those as claimed so they can't be collected twice.
        let paidTitles = Set(history.map { $0.title })
        var didMigrate = false
        for index in goals.indices where goals[index].completedAt != nil && goals[index].rewardClaimed == nil {
            goals[index].rewardClaimed = paidTitles.contains(goals[index].title)
            didMigrate = true
        }
        if didMigrate {
            save()
        }
    }

    func clearHistory() {
        // Keep any legacy paid-out goals marked as claimed before the records
        // that prove it are removed.
        let paidTitles = Set(history.map { $0.title })
        for index in goals.indices where goals[index].completedAt != nil
            && goals[index].rewardClaimed == nil
            && paidTitles.contains(goals[index].title) {
            goals[index].rewardClaimed = true
        }

        history = []
        save()
    }

    func save() {
        if let data = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(data, forKey: "goals_v1")
        }
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: "goal_history_v1")
        }
        UserDefaults.standard.set(currency, forKey: "goal_currency_v1")
    }
}

private extension View {
    func rowStyling(top: CGFloat = 4, bottom: CGFloat = 4) -> some View {
        self
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: top, leading: 20, bottom: bottom, trailing: 20))
    }
}
