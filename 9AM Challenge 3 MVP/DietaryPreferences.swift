//
//  DietaryPreferences.swift
//  9AM Challenge 3 MVP
//
//  Dietary restriction matching, restaurant ranking, and the little Munchkin
//  message shown alongside each restaurant result.
//

import SwiftUI

// MARK: - Restrictions

struct DietaryRestriction: Hashable, Identifiable {
    let key: String
    let label: String
    /// Words in a restaurant's name/cuisine that suggest it fits.
    let positive: [String]
    /// Words that suggest it does not fit.
    let negative: [String]

    var id: String { key }

    static let vegetarian = DietaryRestriction(
        key: "dietVegetarian",
        label: "vegetarian",
        positive: [
            "vegetarian", "vegan", "veggie", "veg", "meat-free", "meat free",
            "plant-based", "plant based", "greens", "salad", "organic",
            "healthy", "juice", "smoothie"
        ],
        negative: [
            "steak", "seafood", "bbq", "barbecue", "chicken", "pork", "bacon",
            "hotpot", "burger", "grill", "fish", "meat", "kebab", "sausage",
            "ham", "duck", "lamb", "satay", "rendang", "fried rice"
        ]
    )

    static let vegan = DietaryRestriction(
        key: "dietVegan",
        label: "vegan",
        positive: [
            "vegan", "plant-based", "plant based", "plantbased", "meat-free",
            "meat free", "greens", "salad", "organic", "juice", "smoothie",
            "raw food"
        ],
        negative: [
            "steak", "seafood", "bbq", "barbecue", "chicken", "pork", "bacon",
            "hotpot", "burger", "grill", "fish", "meat", "kebab", "sausage",
            "ham", "duck", "lamb", "satay", "rendang", "cheese", "ice cream",
            "gelato", "milk", "egg", "honey", "yogurt", "butter", "cream"
        ]
    )

    static let halal = DietaryRestriction(
        key: "dietHalal",
        label: "halal-friendly",
        positive: ["halal", "halal-friendly", "halal friendly"],
        negative: ["pork", "bacon", "ham", "liquor", "alcohol", "pub", "sausage"]
    )

}

struct DietaryPreferences {
    var vegetarian: Bool
    var vegan: Bool
    var halal: Bool

    /// Reads the same keys the Profile toggles write to.
    static func current() -> DietaryPreferences {
        let defaults = UserDefaults.standard
        return DietaryPreferences(
            vegetarian: defaults.bool(forKey: "dietVegetarian"),
            vegan: defaults.bool(forKey: "dietVegan"),
            halal: defaults.bool(forKey: "dietHalal")
        )
    }

    var active: [DietaryRestriction] {
        var restrictions: [DietaryRestriction] = []
        if vegetarian { restrictions.append(.vegetarian) }
        if vegan { restrictions.append(.vegan) }
        if halal { restrictions.append(.halal) }
        return restrictions
    }

    var isEmpty: Bool { active.isEmpty }

    var summaryMessage: String {
        guard !isEmpty else {
            return "Pick a dietary restriction and I'll push the spots that fit it to the top!"
        }
        let needs = active.count == 1
            ? "all of your dietary needs"
            : "all \(active.count) of your dietary needs"
        return "I'll only recommend spots that match \(needs) — no maybes!"
    }
}

// MARK: - Adherence

struct DietAdherence {
    let matched: [DietaryRestriction]
    let uncertain: [DietaryRestriction]
    let conflicting: [DietaryRestriction]
    let total: Int

    var adheresToAll: Bool { conflicting.isEmpty && uncertain.isEmpty }

    var message: String {
        if total == 0 {
            return "No dietary restrictions set — Munchkin says every spot is fair game!"
        }
        if adheresToAll {
            let needs = total == 1
                ? "all of your dietary needs"
                : "all \(total) of your dietary needs"
            return "Munchkin checked what we know: this spot matches \(needs)! ✅"
        }

        let confirmed = matched.map(\.label)
        let unsure = uncertain.map(\.label)
        let clashes = conflicting.map(\.label)

        if conflicting.isEmpty {
            if confirmed.isEmpty {
                return "Munchkin can't confirm \(joined(unsure)) here — please check with the restaurant."
            }
            return "Munchkin can confirm \(joined(confirmed)), but isn't sure about \(joined(unsure)) here."
        }

        if confirmed.isEmpty && unsure.isEmpty {
            return "Munchkin spotted a possible clash with \(joined(clashes)) here — please double-check."
        }

        let confirmedText = confirmed.isEmpty ? "nothing confirmed" : joined(confirmed)
        let unsureText = unsure.isEmpty ? "" : ", and isn't sure about \(joined(unsure))"
        return "Munchkin found \(confirmedText)\(unsureText), but spotted a possible clash with \(joined(clashes))."
    }

    var tint: Color {
        if total == 0 { return Color.gray.opacity(0.12) }
        if adheresToAll { return Color.green.opacity(0.16) }
        if conflicting.isEmpty { return Color.orange.opacity(0.15) }
        return Color.red.opacity(0.12)
    }

    private func joined(_ items: [String]) -> String {
        switch items.count {
        case 0: return ""
        case 1: return items[0]
        case 2: return "\(items[0]) and \(items[1])"
        default: return "\(items.dropLast().joined(separator: ", ")), and \(items[items.count - 1])"
        }
    }
}

extension Restaurant {
    /// Keyword-based adherence: the bundled data has no dietary tags, so this
    /// uses the restaurant name and cuisine and is deliberately worded as a
    /// "best guess" in the Munchkin message.
    func dietAdherence(for preferences: DietaryPreferences) -> DietAdherence {
        let searchableText = "\(name) \(cuisine)".lowercased()

        var matched: [DietaryRestriction] = []
        var uncertain: [DietaryRestriction] = []
        var conflicting: [DietaryRestriction] = []

        for restriction in preferences.active {
            if restriction.positive.contains(where: { searchableText.contains($0) }) {
                matched.append(restriction)
            } else if restriction.negative.contains(where: { searchableText.contains($0) }) {
                conflicting.append(restriction)
            } else {
                uncertain.append(restriction)
            }
        }

        // A vegan spot also satisfies a vegetarian restriction.
        if matched.contains(where: { $0.key == "dietVegan" }) {
            let impliedVegetarian = uncertain.first { $0.key == "dietVegetarian" }
                ?? conflicting.first { $0.key == "dietVegetarian" }
            uncertain.removeAll { $0.key == "dietVegetarian" }
            conflicting.removeAll { $0.key == "dietVegetarian" }
            if let impliedVegetarian { matched.append(impliedVegetarian) }
        }

        return DietAdherence(
            matched: matched,
            uncertain: uncertain,
            conflicting: conflicting,
            total: preferences.active.count
        )
    }
}

// MARK: - Filtering

extension RestaurantDirectory {
    /// Only restaurants that satisfy every selected restriction are returned.
    /// When no restrictions are selected, every restaurant is eligible.
    static func matchingDiet(
        _ restaurants: [Restaurant],
        using preferences: DietaryPreferences
    ) -> [Restaurant] {
        guard !preferences.isEmpty else { return restaurants }
        return restaurants.filter { $0.dietAdherence(for: preferences).adheresToAll }
    }

    /// Weekly picks that honour every restriction. Curated picks come first,
    /// then the rest of the directory so no matching restaurant is overlooked.
    static func dietAwareWeeklyPicks(
        for region: RestaurantRegion,
        using preferences: DietaryPreferences
    ) -> [Restaurant] {
        guard !preferences.isEmpty else { return weeklyPicks(for: region) }

        let safeDirectory = matchingDiet(restaurants(in: region), using: preferences)
        var result = matchingDiet(weeklyPicks(for: region), using: preferences)
        var seenIDs = Set(result.map(\.id))

        for restaurant in safeDirectory where !seenIDs.contains(restaurant.id) {
            result.append(restaurant)
            seenIDs.insert(restaurant.id)
        }
        return result
    }

}

// MARK: - Munchkin message

struct MunchkinDietMessage: View {
    let adherence: DietAdherence
    var showMascot: Bool = true

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(adherence.message)
                .font(.dynaPuff(13))
                .foregroundStyle(.primary)
                .padding(10)
                .background(adherence.tint)
                .clipShape(RoundedRectangle(cornerRadius: 14))

            if showMascot {
                MunchkinAvatarView(size: 32)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
