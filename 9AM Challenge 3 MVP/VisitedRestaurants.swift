//
//  VisitedRestaurants.swift
//  9AM Challenge 3 MVP
//
//  Remembers which restaurants the user has actually eaten at. A restaurant
//  can only ever count once towards the "try new restaurants" goals.
//

import Foundation

enum VisitedRestaurants {
    private static let key = "visited_restaurant_ids_v1"

    static func all() -> Set<String> {
        let defaults = UserDefaults.standard

        if let data = defaults.data(forKey: key),
           let saved = try? JSONDecoder().decode([String].self, from: data) {
            return Set(saved)
        }

        // Older builds had no visited list. A saved review means the spot was
        // already eaten at, so seed the list from review history.
        let migrated = Set(
            ReviewHistory.all().compactMap { review in
                RestaurantDirectory.all.first { $0.name == review.restaurantName }?.id
            }
        )
        if !migrated.isEmpty { save(migrated) }
        return migrated
    }

    static func contains(_ id: String) -> Bool {
        all().contains(id)
    }

    /// Returns true only the first time a restaurant is marked as visited.
    @discardableResult
    static func markVisited(_ id: String) -> Bool {
        var ids = all()
        let inserted = ids.insert(id).inserted
        if inserted { save(ids) }
        return inserted
    }

    private static func save(_ ids: Set<String>) {
        guard let data = try? JSONEncoder().encode(ids.sorted()) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

/// A checked restaurant donates one point to a specific goal. Storing the
/// pairing lets unchecking take exactly that point back.
struct RestaurantGoalCredit: Codable {
    let restaurantID: String
    let goalID: UUID
}

enum RestaurantGoalCredits {
    private static let key = "restaurant_goal_credits_v1"

    static func all() -> [RestaurantGoalCredit] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([RestaurantGoalCredit].self, from: data)
        else { return [] }
        return decoded
    }

    static func credit(for restaurantID: String) -> RestaurantGoalCredit? {
        all().first { $0.restaurantID == restaurantID }
    }

    static func add(_ credit: RestaurantGoalCredit) {
        var credits = all().filter { $0.restaurantID != credit.restaurantID }
        credits.append(credit)
        save(credits)
    }

    @discardableResult
    static func remove(for restaurantID: String) -> RestaurantGoalCredit? {
        let credits = all()
        guard let found = credits.first(where: { $0.restaurantID == restaurantID }) else { return nil }
        save(credits.filter { $0.restaurantID != restaurantID })
        return found
    }

    private static func save(_ credits: [RestaurantGoalCredit]) {
        guard let data = try? JSONEncoder().encode(credits) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
