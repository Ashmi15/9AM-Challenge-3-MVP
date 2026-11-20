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

/// Shared by the Goals tab and the Home screen so a reward can only ever be
/// paid out once, no matter where it is claimed.
enum GoalClaim {
    static func claim(_ id: UUID) {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: "goals_v1"),
              var goals = try? JSONDecoder().decode([GoalItem].self, from: data),
              let index = goals.firstIndex(where: { $0.id == id }),
              goals[index].completedAt != nil,
              goals[index].rewardClaimed != true else { return }

        let reward = GoalReward.coins(for: goals[index].difficulty)
        var history = defaults.data(forKey: "goal_history_v1")
            .flatMap { try? JSONDecoder().decode([CompletedGoalRecord].self, from: $0) } ?? []

        history.append(CompletedGoalRecord(
            title: goals[index].title,
            difficulty: goals[index].difficulty,
            reward: reward,
            completedAt: goals[index].completedAt ?? Date()
        ))
        goals[index].rewardClaimed = true

        if let goalData = try? JSONEncoder().encode(goals) {
            defaults.set(goalData, forKey: "goals_v1")
        }
        if let historyData = try? JSONEncoder().encode(history) {
            defaults.set(historyData, forKey: "goal_history_v1")
        }
        defaults.set(
            defaults.integer(forKey: "goal_currency_v1") + reward,
            forKey: "goal_currency_v1"
        )
    }
}

// MARK: - Data repairs

/// One-time fixes for goal data written by older builds.
enum GoalRewardRepair {
    /// Restores goals that an older build hid by matching on title alone.
    ///
    /// That check marked a freshly completed goal as "claimed" whenever the
    /// same title had ever been paid out before, so the goal disappeared from
    /// the Goals tab without any coins being awarded. A genuinely claimed goal
    /// has a history record with the same title *and* the same completion
    /// date, so anything else with a matching title goes back to unclaimed.
    static func runIfNeeded() {
        let repairKey = "goals_claim_repair_v1"
        guard !UserDefaults.standard.bool(forKey: repairKey) else { return }
        UserDefaults.standard.set(true, forKey: repairKey)

        guard let goalData = UserDefaults.standard.data(forKey: "goals_v1"),
              var goals = try? JSONDecoder().decode([GoalItem].self, from: goalData) else { return }

        let history = UserDefaults.standard.data(forKey: "goal_history_v1")
            .flatMap { try? JSONDecoder().decode([CompletedGoalRecord].self, from: $0) } ?? []

        var didRepair = false
        for index in goals.indices {
            guard let completedAt = goals[index].completedAt,
                  goals[index].rewardClaimed == true else { continue }

            let title = goals[index].title
            let hasOwnRecord = history.contains {
                $0.title == title && abs($0.completedAt.timeIntervalSince(completedAt)) < 2
            }
            let hasOtherRecord = history.contains { $0.title == title }

            if !hasOwnRecord && hasOtherRecord {
                goals[index].rewardClaimed = false
                didRepair = true
            }
        }

        if didRepair, let data = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(data, forKey: "goals_v1")
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
    @State private var clearPrompt: ClearPrompt?
    @State private var newTitle = ""
    @State private var newTarget = 1

    private let backgroundColor = Color(red: 1.0, green: 0.97, blue: 0.93)
    private let cardColor = Color.white

    /// Completed goals that still owe coins. Kept at the top of the list so
    /// they are impossible to miss.
    private var claimableGoals: [GoalItem] {
        goals.filter { $0.completedAt != nil && $0.rewardClaimed != true }
    }

    private var activeGoals: [GoalItem] {
        goals.filter { $0.completedAt == nil && $0.rewardClaimed != true }
    }

    private var sortedHistory: [CompletedGoalRecord] {
        history.sorted { $0.completedAt > $1.completedAt }
    }

    var body: some View {
        NavigationStack {
            List {
                // Completed goals waiting for their coins
                if !claimableGoals.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "gift.fill")
                            .foregroundStyle(.green)

                        Text("Ready to Claim")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .rowStyling(top: 12, bottom: 0)

                    ForEach(claimableGoals) { g in
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

                // Active goals
                HStack(alignment: .firstTextBaseline) {
                    Text("Active Goals")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Spacer()

                    if !activeGoals.isEmpty {
                        Button("Clear") {
                            clearPrompt = .active
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.orange)
                    }
                }
                .rowStyling(top: 12, bottom: 0)

                if activeGoals.isEmpty {
                    Text(
                        claimableGoals.isEmpty
                            ? "No active goals. Add one below."
                            : "Nothing in progress. Add another goal below."
                    )
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
                            clearPrompt = .history
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteHistory(h.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(backgroundColor)
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("💰 \(currency)")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
            }
            .onAppear(perform: load)
            .fullScreenCover(item: $clearPrompt) { prompt in
                ClearConfirmationView(
                    prompt: prompt,
                    onConfirm: {
                        switch prompt {
                        case .history:
                            clearAllHistory()
                        case .active:
                            clearActiveGoals()
                        }
                        clearPrompt = nil
                    },
                    onCancel: {
                        clearPrompt = nil
                    }
                )
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

    func clearActiveGoals() {
        goals.removeAll { $0.completedAt == nil }
        save()
    }

    func deleteGoal(_ id: UUID) {
        goals.removeAll { $0.id == id }
        save()
    }

    func deleteHistory(_ id: UUID) {
        history.removeAll { $0.id == id }
        save()
    }

    func claimReward(_ id: UUID) {
        GoalClaim.claim(id)
        load()
    }

    func load() {
        // Run before decoding so the list reflects any repaired state.
        GoalRewardRepair.runIfNeeded()

        if let data = UserDefaults.standard.data(forKey: "goals_v1"),
           let decoded = try? JSONDecoder().decode([GoalItem].self, from: data) {
            goals = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "goal_history_v1"),
           let decoded = try? JSONDecoder().decode([CompletedGoalRecord].self, from: data) {
            history = decoded
        }
        currency = UserDefaults.standard.integer(forKey: "goal_currency_v1")

        // Goals completed by very old builds may already have been paid out.
        // Only treat one as paid if history has a record for the same title at
        // the same completion time; title alone is not proof (that was the bug
        // that hid freshly completed goals).
        var didMigrate = false
        for index in goals.indices where goals[index].completedAt != nil && goals[index].rewardClaimed == nil {
            guard let completedAt = goals[index].completedAt else { continue }
            let title = goals[index].title
            let wasPaid = history.contains {
                $0.title == title && abs($0.completedAt.timeIntervalSince(completedAt)) < 2
            }
            if wasPaid {
                goals[index].rewardClaimed = true
                didMigrate = true
            }
        }
        if didMigrate {
            save()
        }
    }

    /// Wipes the whole history in one tap. Goals that still say
    /// rewardClaimed != true stay claimable, so clearing the log can never
    /// swallow a reward the user has not collected yet.
    func clearAllHistory() {
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

/// Which list a full-screen clear confirmation is asking about.
enum ClearPrompt: String, Identifiable {
    case history
    case active

    var id: String { rawValue }

    var title: String {
        switch self {
        case .history: return "Clear history?"
        case .active: return "Clear active goals?"
        }
    }

    var message: String {
        switch self {
        case .history:
            return "This removes completed goal records. Your coins and active goals stay as they are."
        case .active:
            return "This removes the goals you're still working on. Completed goals waiting to be claimed, your coins and your history stay."
        }
    }

    var icon: String {
        switch self {
        case .history: return "clock.arrow.circlepath"
        case .active: return "checklist.unchecked"
        }
    }

    var confirmTitle: String {
        switch self {
        case .history: return "Clear History"
        case .active: return "Clear Active Goals"
        }
    }
}

/// Full-screen confirmation so the warning is impossible to miss instead of
/// tucked into a bottom action sheet.
private struct ClearConfirmationView: View {
    let prompt: ClearPrompt
    let onConfirm: () -> Void
    let onCancel: () -> Void

    private let backgroundColor = Color(red: 1.0, green: 0.97, blue: 0.93)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer(minLength: 12)

                Image(systemName: prompt.icon)
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(.orange)
                    .frame(width: 118, height: 118)
                    .background(Circle().fill(Color.orange.opacity(0.15)))

                Text(prompt.title)
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)

                Text(prompt.message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                Spacer(minLength: 8)

                VStack(spacing: 12) {
                    Button(role: .destructive) {
                        onConfirm()
                    } label: {
                        Text(prompt.confirmTitle)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(Color.white)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    Button {
                        onCancel()
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(.orange)
                            .background(Color.orange.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 28)
        }
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
