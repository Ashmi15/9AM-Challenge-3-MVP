//
//  PetQuestionnaire.swift
//  9AM Challenge 3 MVP
//
//  Turns the short food-preference quiz in onboarding into a pet recommendation.
//

import Foundation

enum PetQuestionnaire {
    struct Option: Identifiable, Hashable {
        let id: String
        let emoji: String
        let label: String
        let persona: FoodPersona
    }

    static let flavours: [Option] = [
        Option(id: "spicy", emoji: "🌶️", label: "Spicy", persona: .fiery),
        Option(id: "sweet", emoji: "🍰", label: "Sweet", persona: .cookie),
        Option(id: "tangy", emoji: "🍋", label: "Tangy", persona: .panda),
        Option(id: "savoury", emoji: "🍜", label: "Savoury", persona: .terry),
        Option(id: "everything", emoji: "🐱", label: "A bit of everything", persona: .munchkin)
    ]

    static let treats: [Option] = [
        Option(id: "ice-cream", emoji: "🍦", label: "Ice cream & cake", persona: .cookie),
        Option(id: "fiery-noodles", emoji: "🍜", label: "Fiery noodles", persona: .fiery),
        Option(id: "citrus", emoji: "🍋", label: "Citrus & tamarind", persona: .panda),
        Option(id: "roast", emoji: "🍗", label: "A hearty roast", persona: .terry),
        Option(id: "surprise", emoji: "🎲", label: "Surprise me", persona: .munchkin)
    ]

    /// Scores each persona from the quiz answers and returns the best fit with
    /// a short explanation that can be shown on the recommendation screen.
    static func recommend(
        flavours: Set<String>,
        treat: String?
    ) -> (persona: FoodPersona, explanation: String) {
        var scores: [FoodPersona: Int] = [:]

        let chosenFlavours = Self.flavours.filter { flavours.contains($0.id) }
        for option in chosenFlavours {
            scores[option.persona, default: 0] += 2
        }

        let chosenTreat = Self.treats.first { $0.id == treat }
        if let chosenTreat {
            scores[chosenTreat.persona, default: 0] += 3
        }

        // Loving every flavour (or three or more) is Munchkin's kind of appetite.
        let distinctTastes = Set(
            chosenFlavours.filter { $0.persona != .munchkin }.map(\.persona)
        )
        if chosenFlavours.contains(where: { $0.persona == .munchkin }) || distinctTastes.count >= 3 {
            scores[.munchkin, default: 0] += 4
        }

        let winner = FoodPersona.allCases.sorted { lhs, rhs in
            let lhsScore = scores[lhs] ?? 0
            let rhsScore = scores[rhs] ?? 0
            if lhsScore != rhsScore { return lhsScore > rhsScore }
            return lhs.rawValue < rhs.rawValue
        }.first ?? .munchkin

        var reasons: [String] = []
        if !chosenFlavours.isEmpty {
            reasons.append(
                "you love \(chosenFlavours.map(\.label).joined(separator: ", ").lowercased())"
            )
        }
        if let chosenTreat {
            reasons.append("your perfect treat is \(chosenTreat.label.lowercased())")
        }

        let why = reasons.isEmpty
            ? "you're still discovering your tastes"
            : reasons.joined(separator: " and ")
        let explanation = "Based on what you told us — \(why) — \(winner.name) is your starting Munchkin!"

        return (winner, explanation)
    }
}
