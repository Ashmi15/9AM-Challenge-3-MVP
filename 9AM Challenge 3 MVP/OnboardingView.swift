//
//  OnboardingView.swift
//  9AM Challenge 3 MVP
//
//  First-launch welcome, tutorial, food quiz, pet recommendation and setup.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("preferredLocation") private var preferredLocation = "Anywhere"
    @AppStorage("preferredBudget") private var preferredBudget = "$10–$25"
    @AppStorage("dietVegetarian") private var vegetarian = false
    @AppStorage("dietVegan") private var vegan = false
    @AppStorage("dietHalal") private var halal = false
    @AppStorage("dietGlutenFree") private var glutenFree = false
    @AppStorage("dietDairyFree") private var dairyFree = false

    @State private var step: Step = .welcome
    @State private var selectedFlavours: Set<String> = []
    @State private var selectedTreat: String?

    private enum Step: Int, CaseIterable {
        case welcome
        case tutorial
        case questions
        case recommendation
        case preferences
    }

    private let locations = ["Anywhere", "North", "South", "East", "West", "Central"]
    private let budgets = ["Under $10", "$10–$25", "$25–$50", "$50+"]

    private let answerColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    private var diet: DietaryPreferences {
        DietaryPreferences(
            vegetarian: vegetarian,
            vegan: vegan,
            halal: halal,
            glutenFree: glutenFree,
            dairyFree: dairyFree
        )
    }

    private var recommendation: (persona: FoodPersona, explanation: String) {
        PetQuestionnaire.recommend(flavours: selectedFlavours, treat: selectedTreat)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Skip") { finish() }
                .font(.subheadline)

                Spacer()

                Text("Step \(step.rawValue + 1) of \(Step.allCases.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)

            HStack(spacing: 6) {
                ForEach(Step.allCases, id: \.self) { page in
                    Capsule()
                        .fill(page.rawValue <= step.rawValue ? Color.orange : Color.gray.opacity(0.2))
                        .frame(height: 5)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)

            ScrollView {
                Group {
                    switch step {
                    case .welcome: welcomePage
                    case .tutorial: tutorialPage
                    case .questions: questionsPage
                    case .recommendation: recommendationPage
                    case .preferences: preferencesPage
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }

            HStack {
                if step != .welcome {
                    Button("Back") { goBack() }
                }

                Spacer()

                Button(step == .preferences ? "Start Munching" : "Next") {
                    goNext()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .disabled(step == .questions && selectedFlavours.isEmpty && selectedTreat == nil)
            }
            .padding(20)
        }
        .background(Color(red: 1.0, green: 0.97, blue: 0.93).ignoresSafeArea())
    }

    // MARK: Navigation

    private func goNext() {
        if step == .questions {
            applyRecommendation()
        }

        guard let next = Step(rawValue: step.rawValue + 1) else {
            finish()
            return
        }
        withAnimation { step = next }
    }

    private func goBack() {
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        withAnimation { step = previous }
    }

    private func applyRecommendation() {
        let result = recommendation
        FoodPersonaStore.setPreferredPersona(result.persona, reason: result.explanation)
    }

    private func toggleFlavour(_ id: String) {
        if selectedFlavours.contains(id) {
            selectedFlavours.remove(id)
        } else {
            selectedFlavours.insert(id)
        }
    }

    private func finish() {
        _ = FoodPersonaStore.resolve(force: true)
        dismiss()
    }

    // MARK: Pages

    private var welcomePage: some View {
        VStack(spacing: 20) {
            Text(MunchkinPet.emoji)
                .font(.system(size: 90))
                .frame(width: 150, height: 150)
                .background(Color.orange.opacity(0.15))
                .clipShape(Circle())

            Text("Welcome to Munchkin!")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("Your pocket food guide for Singapore. Tell us what you love and we'll find the good stuff.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 18) {
                infoRow(
                    "sparkles",
                    "A pet that knows you",
                    "Answer two quick food questions and I'll pick your Munchkin."
                )
                infoRow(
                    "leaf.fill",
                    "Diet-first recommendations",
                    "We only suggest spots that match every dietary need you select."
                )
                infoRow(
                    "magnifyingglass",
                    "Every restaurant, one search",
                    "Browse the full directory in Explore, with region and diet filters."
                )
            }
            .padding(20)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .frame(maxWidth: .infinity)
    }

    private var tutorialPage: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("A quick tour")
                .font(.title2.bold())

            Text("Five tabs, one very well-fed pet.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(spacing: 14) {
                tutorialRow(
                    "house.fill",
                    "Home",
                    "Meet the pet matched to your taste and see your top three picks."
                )
                tutorialRow(
                    "magnifyingglass",
                    "Explore",
                    "Search every restaurant by name, cuisine or area."
                )
                tutorialRow(
                    "target",
                    "Goals",
                    "Collect little food challenges and earn coins."
                )
                tutorialRow(
                    "mug.fill",
                    "Munchie Mixer",
                    "Choose your cravings and get restaurants that match them."
                )
                tutorialRow(
                    "person.crop.circle.fill",
                    "Profile",
                    "See which pet matches your reviews, change preferences, or open the Munchkin Shop."
                )
            }
            .padding(20)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 22))

            Text("After a meal, leave a rating and review in any restaurant — that's how your pet learns what you love!")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var questionsPage: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What do you love to eat?")
                .font(.title2.bold())

            Text("Two quick questions and I'll pick the Munchkin that fits you best.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Which flavours make you happiest?")
                        .font(.headline)

                    Text("Pick as many as you like.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: answerColumns, spacing: 10) {
                        ForEach(PetQuestionnaire.flavours) { option in
                            answerButton(
                                option: option,
                                isSelected: selectedFlavours.contains(option.id)
                            ) {
                                toggleFlavour(option.id)
                            }
                        }
                    }
                }
                .padding(18)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 10) {
                    Text("2. What's your perfect treat?")
                        .font(.headline)

                    LazyVGrid(columns: answerColumns, spacing: 10) {
                        ForEach(PetQuestionnaire.treats) { option in
                            answerButton(
                                option: option,
                                isSelected: selectedTreat == option.id
                            ) {
                                selectedTreat = option.id
                            }
                        }
                    }
                }
                .padding(18)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var recommendationPage: some View {
        VStack(spacing: 20) {
            Text("Meet your starting Munchkin!")
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            VStack(spacing: 14) {
                Text(recommendation.persona.emoji)
                    .font(.system(size: 88))
                    .frame(width: 150, height: 150)
                    .background(recommendation.persona.accent)
                    .clipShape(Circle())

                Text(recommendation.persona.name)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text(recommendation.persona.tagline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text(recommendation.explanation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text("Rate a few restaurants and I'll change to match your reviews.")
                    .font(.caption2)
                    .foregroundStyle(.teal)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))

            Button {
                goNext()
            } label: {
                Label("Looks good — continue", systemImage: "checkmark.circle.fill")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)

        }
        .frame(maxWidth: .infinity)
    }

    private var preferencesPage: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Make it yours")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Preferred location", systemImage: "mappin.circle.fill")
                        .font(.headline)

                    Picker("Location", selection: $preferredLocation) {
                        ForEach(locations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .tint(.teal)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Label("Budget per person", systemImage: "dollarsign.circle.fill")
                        .font(.headline)

                    Picker("Budget", selection: $preferredBudget) {
                        ForEach(budgets, id: \.self) { budget in
                            Text(budget).tag(budget)
                        }
                    }
                    .tint(.teal)
                }

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Label("Dietary needs", systemImage: "leaf.fill")
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
            .clipShape(RoundedRectangle(cornerRadius: 22))

            Text("Don't worry — you can change all of this later in Profile.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Helpers

    @ViewBuilder
    private func answerButton(
        option: PetQuestionnaire.Option,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(option.emoji)
                    .font(.title3)

                Text(option.label)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(isSelected ? Color.orange.opacity(0.18) : Color.gray.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func infoRow(_ icon: String, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.orange)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private func tutorialRow(_ icon: String, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.teal)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
