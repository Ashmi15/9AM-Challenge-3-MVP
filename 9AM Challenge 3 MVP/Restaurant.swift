//
//  Restaurant.swift
//  9AM Challenge 3 MVP
//
//  Restaurant data loaded from restaurants-singapore-sg.csv
//

import Foundation

/// Broad regions used by the Profile preference and the recommendation filters.
enum RestaurantRegion: String, CaseIterable, Identifiable {
    case anywhere = "Anywhere"
    case north = "North"
    case south = "South"
    case east = "East"
    case west = "West"
    case central = "Central"

    var id: String { rawValue }

    var isAnywhere: Bool { self == .anywhere }

    static func from(preference: String) -> RestaurantRegion {
        RestaurantRegion(rawValue: preference) ?? .anywhere
    }

    /// Maps a CSV `nearest_area` to one of the broad regions.
    static func forArea(_ area: String, latitude: Double, longitude: Double) -> RestaurantRegion {
        let key = area.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let known = areaLookup[key] {
            return known
        }

        // Fallback for any new areas added to the CSV.
        guard latitude != 0, longitude != 0 else { return .central }
        if latitude < 1.272 { return .south }
        if longitude < 103.78 { return .west }
        if latitude > 1.36 && longitude < 103.88 { return .north }
        if longitude > 103.885 { return .east }
        return .central
    }

    private static let areaLookupRegions: [(RestaurantRegion, [String])] = [
        (.north, [
            "Admiralty", "Ang Mo Kio", "Canberra", "Chencharu", "Chong Pang",
            "Fernvale", "Kebun Baru", "Lentor", "Marsiling", "North Region",
            "North-east Region", "Sembawang", "Simpang", "Thomson",
            "Upper Thomson", "Woodlands", "Yishun"
        ]),
        (.south, [
            "Fort Siloso", "HarbourFront", "Sentosa Cove", "Southern Islands"
        ]),
        (.east, [
            "Bedok", "Bedok South", "Chai Chee", "Changi",
            "Changi Business Park", "Changi Village", "Compassvale",
            "East Region", "Eunos", "Geylang", "Hougang", "Joo Chiat",
            "Kaki Bukit", "Kovan", "Marine Parade", "Pasir Ris",
            "Paya Lebar", "Punggol", "Sengkang", "Tai Seng", "Tampines",
            "Telok Kurau"
        ]),
        (.west, [
            "Beauty World", "Bukit Batok", "Bukit Gombak", "Bukit Panjang",
            "Bukit Timah", "Choa Chu Kang", "Clementi", "Jurong East",
            "Jurong West", "Neo Tiew Estate", "Pioneer", "Queenstown",
            "Sungei Kadut", "Tengah", "Ulu Pandan", "Upper Bukit Timah",
            "West Region", "Yew Tee", "Yuhua"
        ])
    ]

    private static let areaLookup: [String: RestaurantRegion] = {
        var lookup: [String: RestaurantRegion] = [:]
        for (region, areas) in areaLookupRegions {
            for area in areas {
                lookup[area.lowercased()] = region
            }
        }
        return lookup
    }()
}

/// How a restaurant's menu fits a plant-based diet. Curated venues carry an
/// explicit class; the OpenStreetMap export leaves this `nil` and falls back
/// to keyword matching.
enum DietClass: String, Hashable {
    /// Fully vegan — no meat, dairy, eggs or honey.
    case vegan
    /// Vegetarian restaurant that also offers vegan choices.
    case vegetarianWithVeganOptions
    /// Vegetarian only; vegan dishes are not guaranteed.
    case vegetarian
    /// Mixed menu (serves meat) but with dedicated vegan options.
    case mixedWithVeganOptions
}

struct Restaurant: Identifiable, Hashable {
    let id: String
    let name: String
    let cuisine: String
    let area: String
    let address: String
    let postcode: String
    let phone: String
    let website: String
    let latitude: Double
    let longitude: Double
    let isStale: Bool
    /// Explicit dietary classification for curated venues. `nil` means the
    /// restaurant came from the OpenStreetMap export and has no diet tags.
    var dietClass: DietClass? = nil
    /// Short editorial blurb for curated venues, shown on the detail screen.
    var summary: String = ""

    /// "Japanese • Tanjong Pagar"
    var description: String {
        "\(cuisine) • \(area)"
    }

    /// The broad region used by the Profile preference and filters.
    var region: RestaurantRegion {
        RestaurantRegion.forArea(area, latitude: latitude, longitude: longitude)
    }

    /// "Tanjong Pagar, 165 Tanjong Pagar Road, Singapore 088539"
    var locationLine: String {
        var parts = [area]
        if !address.isEmpty {
            parts.append(address)
        }
        parts.append(postcode.isEmpty ? "Singapore" : "Singapore \(postcode)")
        return parts.joined(separator: ", ")
    }

    var websiteURL: URL? {
        guard !website.isEmpty,
              let url = URL(string: website),
              url.scheme != nil else { return nil }
        return url
    }

    var emoji: String {
        // Curated venues use a diet marker so vegan and vegetarian spots are
        // recognisable at a glance, regardless of cuisine.
        if let dietClass {
            switch dietClass {
            case .vegan: return "🌱"
            case .vegetarianWithVeganOptions, .vegetarian: return "🥬"
            case .mixedWithVeganOptions: break
            }
        }

        let lowercasedCuisine = cuisine.lowercased()
        for (keyword, emoji) in Self.emojiKeywords
        where lowercasedCuisine.contains(keyword) {
            return emoji
        }
        return "🍽️"
    }

    var recommendationReason: String {
        let lowercasedCuisine = cuisine.lowercased()
        for (keyword, reason) in Self.reasonTemplates
        where lowercasedCuisine.contains(keyword) {
            return reason.replacingOccurrences(of: "{area}", with: area)
        }
        return "Munchkin thinks this \(cuisine.lowercased()) spot in \(area) is worth a try!"
    }

    /// Cravings (from the Munchie Mixer) that this restaurant can satisfy.
    func matchingCravings(_ cravings: [String]) -> [String] {
        let searchableText = "\(cuisine) \(name)".lowercased()
        return cravings.filter { craving in
            Self.cravingKeywords[craving]?.contains(where: { keyword in
                searchableText.contains(keyword)
            }) ?? false
        }
    }

    static let preview = Restaurant(
        id: "preview",
        name: "Mala Hotpot",
        cuisine: "Hotpot",
        area: "Chinatown",
        address: "12 Smith Street",
        postcode: "058926",
        phone: "+65 6123 4567",
        website: "",
        latitude: 1.2815,
        longitude: 103.8440,
        isStale: false
    )

    private static let emojiKeywords: [(String, String)] = [
        ("sushi", "🍣"),
        ("ramen", "🍜"),
        ("noodle", "🍜"),
        ("japanese", "🍣"),
        ("korean", "🍲"),
        ("hotpot", "🍲"),
        ("steamboat", "🍲"),
        ("indian", "🍛"),
        ("curry", "🍛"),
        ("malaysian", "🍛"),
        ("indonesian", "🍛"),
        ("thai", "🍜"),
        ("vietnamese", "🍜"),
        ("taiwanese", "🥟"),
        ("chinese", "🥟"),
        ("dim sum", "🥟"),
        ("italian", "🍝"),
        ("pizza", "🍕"),
        ("burger", "🍔"),
        ("american", "🍔"),
        ("western", "🍔"),
        ("mexican", "🌮"),
        ("spanish", "🥘"),
        ("french", "🥐"),
        ("turkish", "🥙"),
        ("greek", "🥙"),
        ("seafood", "🦐"),
        ("steak", "🥩"),
        ("barbecue", "🍖"),
        ("bbq", "🍖"),
        ("grill", "🍖"),
        ("dessert", "🍰"),
        ("bakery", "🥐"),
        ("cake", "🍰"),
        ("coffee", "☕"),
        ("cafe", "☕"),
        ("salad", "🥗"),
        ("hawaiian", "🥗"),
        ("vegetarian", "🥗"),
        ("vegan", "🥗"),
        ("singaporean", "🍜"),
        ("malay", "🍛"),
        ("asian", "🍚"),
        ("fusion", "🍚")
    ]

    private static let reasonTemplates: [(String, String)] = [
        ("japanese", "You enjoy savoury, umami flavours — this Japanese spot in {area} could be a great match!"),
        ("sushi", "You enjoy fresh, savoury flavours — this sushi spot in {area} could be a great match!"),
        ("korean", "Bold, comforting Korean flavours in {area} sound like a perfect fit for you!"),
        ("italian", "Sometimes comforting, cheesy food is exactly what you need — especially in {area}!"),
        ("indian", "You've shown an interest in aromatic, spicy dishes — this {area} favourite delivers!"),
        ("thai", "You love bold, spicy flavours, so this Thai spot in {area} is right up your alley!"),
        ("chinese", "These savoury, comforting flavours match your love of familiar favourites!"),
        ("vietnamese", "Fresh, tangy Vietnamese flavours in {area} could be a tasty change of pace!"),
        ("french", "A little indulgence in {area} could be just what your taste buds are asking for!"),
        ("spanish", "Shareable, flavour-packed Spanish dishes in {area} are worth gathering friends for!"),
        ("seafood", "Fresh seafood in {area} is a great pick when you're craving something satisfying!"),
        ("pizza", "Sometimes comforting, cheesy pizza is exactly what the day calls for!"),
        ("turkish", "Rich, savoury Turkish flavours in {area} would make a fun food adventure!"),
        ("mexican", "A little spice and tang in {area} makes this a fun pick for your next meal!"),
        ("malay", "Comforting local Malay flavours in {area} are always a crowd-pleaser!"),
        ("american", "Hearty, comforting American fare in {area} is a solid choice for a hungry day!")
    ]

    private static let cravingKeywords: [String: [String]] = [
        "Spicy": [
            "thai", "indian", "korean", "sichuan", "hotpot", "malaysian",
            "indonesian", "mexican", "curry", "laksa", "nasi", "rendang",
            "chilli", "spicy", "pepper", "mala", "tom yum", "tomyum"
        ],
        "Sweet": [
            "dessert", "bakery", "cake", "cafe", "coffee", "ice cream",
            "gelato", "pastry", "sweet", "bubble tea", "chocolate", "donut",
            "waffle", "pancake"
        ],
        "Salty": [
            "chinese", "japanese", "seafood", "korean", "pizza", "burger",
            "noodle", "ramen", "dim sum", "sushi", "western", "steak",
            "grill", "barbecue", "bbq", "chicken", "fries", "sandwich"
        ],
        "Tangy": [
            "vietnamese", "thai", "filipino", "salad", "mexican", "lime",
            "ceviche", "pickled", "sour"
        ],
        "Savoury": [
            "chinese", "japanese", "korean", "western", "steak", "barbecue",
            "bbq", "noodle", "ramen", "dim sum", "sushi", "grill", "roast",
            "soup", "curry", "rice", "dumpling", "pasta", "italian"
        ],
        "Comforting": [
            "chinese", "japanese", "indian", "noodle", "ramen", "soup",
            "steak", "italian", "pizza", "hotpot", "malay", "singaporean",
            "local", "curry", "rice", "porridge", "bakery", "cafe", "dessert"
        ]
    ]
}

enum RestaurantDirectory {
    /// Every restaurant in the CSV that has a name, cuisine, and area, plus
    /// the curated vegan and vegetarian venues. Curated entries win on a name
    /// clash so their explicit dietary classification is kept.
    static let all: [Restaurant] = {
        let curated = DietaryRestaurants.all
        let curatedNames = Set(curated.map { $0.name.lowercased() })
        let directory = loadRestaurants().filter {
            !curatedNames.contains($0.name.lowercased())
        }
        return (directory + curated).sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }()

    /// A varied, deterministic set of restaurants for the Home and Weekly screens.
    static let weeklyRecommendations: [Restaurant] = makeWeeklyRecommendations(from: all)

    /// Weekly picks limited to a single region.
    static func weeklyPicks(for region: RestaurantRegion) -> [Restaurant] {
        guard !region.isAnywhere else { return weeklyRecommendations }
        return makeWeeklyRecommendations(from: restaurants(in: region))
    }

    /// Restaurants in a region, or every restaurant when `Anywhere` is selected.
    static func restaurants(in region: RestaurantRegion) -> [Restaurant] {
        guard !region.isAnywhere else { return all }
        return all.filter { $0.region == region }
    }

    /// Best matches for the flavours selected in the Munchie Mixer. When
    /// dietary preferences are supplied, every restaurant in the region is
    /// checked and only fully matching spots can be recommended.
    static func recommendations(
        for cravings: [String],
        region: RestaurantRegion = .anywhere,
        maximumResults: Int = 3,
        matching preferences: DietaryPreferences? = nil
    ) -> [Restaurant] {
        guard !cravings.isEmpty else { return [] }

        var candidates = restaurants(in: region)
        let activePreferences = preferences.flatMap { $0.isEmpty ? nil : $0 }
        if let activePreferences {
            candidates = candidates.filter {
                $0.dietAdherence(for: activePreferences).isRecommended
            }
        }

        let ranked = candidates
            .map { restaurant in
                (restaurant: restaurant, matches: restaurant.matchingCravings(cravings).count)
            }
            .filter { $0.matches > 0 }
            .sorted { lhs, rhs in
                if lhs.matches != rhs.matches {
                    return lhs.matches > rhs.matches
                }
                if let activePreferences {
                    let lhsScore = lhs.restaurant.dietAdherence(for: activePreferences).score
                    let rhsScore = rhs.restaurant.dietAdherence(for: activePreferences).score
                    if lhsScore != rhsScore { return lhsScore > rhsScore }
                }
                let lhsHasWebsite = lhs.restaurant.websiteURL != nil
                let rhsHasWebsite = rhs.restaurant.websiteURL != nil
                if lhsHasWebsite != rhsHasWebsite {
                    return lhsHasWebsite
                }
                if lhs.restaurant.isStale != rhs.restaurant.isStale {
                    return !lhs.restaurant.isStale
                }
                return lhs.restaurant.name.localizedCaseInsensitiveCompare(rhs.restaurant.name) == .orderedAscending
            }

        // Prefer a varied set of cuisines over near-identical results.
        var picks: [Restaurant] = []
        var usedIDs = Set<String>()
        var usedCuisines = Set<String>()

        for match in ranked where picks.count < maximumResults {
            let cuisine = match.restaurant.cuisine.lowercased()
            guard !usedCuisines.contains(cuisine) else { continue }
            picks.append(match.restaurant)
            usedIDs.insert(match.restaurant.id)
            usedCuisines.insert(cuisine)
        }

        if picks.count < maximumResults {
            for match in ranked where picks.count < maximumResults {
                guard !usedIDs.contains(match.restaurant.id) else { continue }
                picks.append(match.restaurant)
                usedIDs.insert(match.restaurant.id)
            }
        }

        return picks
    }

    // MARK: - Data loading

    private static func makeWeeklyRecommendations(from candidates: [Restaurant]) -> [Restaurant] {
        let fresh = candidates.filter { !$0.isStale }
        let freshWithWebsite = fresh.filter { $0.websiteURL != nil && !$0.address.isEmpty }

        let pool: [Restaurant]
        if !freshWithWebsite.isEmpty {
            pool = freshWithWebsite
        } else {
            let freshWithAddress = fresh.filter { !$0.address.isEmpty }
            if !freshWithAddress.isEmpty {
                pool = freshWithAddress
            } else if !fresh.isEmpty {
                pool = fresh
            } else {
                pool = candidates
            }
        }

        guard !pool.isEmpty else { return [] }

        let preferredCuisines = [
            "Japanese", "Korean", "Italian", "Indian", "Thai", "Chinese",
            "Vietnamese", "French", "Spanish", "Mexican", "Turkish",
            "Seafood", "Malay", "Greek", "American", "Pizza"
        ]

        var picks: [Restaurant] = []
        var usedIDs = Set<String>()
        var usedNames = Set<String>()

        func add(_ restaurant: Restaurant) {
            picks.append(restaurant)
            usedIDs.insert(restaurant.id)
            usedNames.insert(restaurant.name.lowercased())
        }

        for cuisine in preferredCuisines {
            guard let match = pool.first(where: { restaurant in
                restaurant.cuisine.caseInsensitiveCompare(cuisine) == .orderedSame
                    && !usedIDs.contains(restaurant.id)
                    && !usedNames.contains(restaurant.name.lowercased())
            }) else { continue }
            add(match)
        }

        for restaurant in pool where picks.count < 12 {
            guard !usedIDs.contains(restaurant.id),
                  !usedNames.contains(restaurant.name.lowercased()) else { continue }
            add(restaurant)
        }

        return picks
    }

    private static func loadRestaurants() -> [Restaurant] {
        guard let url = Bundle.main.url(
            forResource: "restaurants-singapore-sg",
            withExtension: "csv"
        ),
        let rawText = try? String(contentsOf: url, encoding: .utf8) else {
            return []
        }

        var text = rawText
        if text.first == "\u{FEFF}" {
            text.removeFirst()
        }

        let rows = parseCSV(text)
        guard let header = rows.first else { return [] }

        let columnIndexes = Dictionary(
            uniqueKeysWithValues: header.enumerated().map {
                ($0.element.trimmingCharacters(in: .whitespacesAndNewlines), $0.offset)
            }
        )

        func value(_ row: [String], _ column: String) -> String {
            guard let index = columnIndexes[column], index < row.count else {
                return ""
            }
            return row[index].trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var restaurants: [Restaurant] = []
        var seenIDs = Set<String>()

        for row in rows.dropFirst() {
            let name = value(row, "name")
            let cuisine = value(row, "detail")
            let area = value(row, "nearest_area")

            guard !name.isEmpty, !cuisine.isEmpty, !area.isEmpty else {
                continue
            }

            let address = value(row, "street_address")
            let postcode = value(row, "postcode")
            let osmURL = value(row, "osm_url")
            let id = osmURL.isEmpty
                ? "\(name)|\(area)|\(address)"
                : osmURL

            guard !seenIDs.contains(id) else { continue }
            seenIDs.insert(id)

            restaurants.append(
                Restaurant(
                    id: id,
                    name: name,
                    cuisine: cuisine,
                    area: area,
                    address: address,
                    postcode: postcode,
                    phone: value(row, "phone"),
                    website: value(row, "website"),
                    latitude: Double(value(row, "latitude")) ?? 0,
                    longitude: Double(value(row, "longitude")) ?? 0,
                    isStale: value(row, "not_edited_in_4_years")
                        .caseInsensitiveCompare("yes") == .orderedSame
                )
            )
        }

        return restaurants.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    /// Minimal RFC 4180-style parser: handles quoted fields, escaped quotes,
    /// and commas or newlines inside quotes.
    private static func parseCSV(_ text: String) -> [[String]] {
        var rows: [[String]] = []
        var row: [String] = []
        var field = ""
        var isInsideQuotes = false
        let characters = Array(text)
        var index = 0

        while index < characters.count {
            let character = characters[index]

            if isInsideQuotes {
                if character == "\"" {
                    let nextIndex = index + 1
                    if nextIndex < characters.count, characters[nextIndex] == "\"" {
                        field.append("\"")
                        index += 2
                        continue
                    }
                    isInsideQuotes = false
                } else {
                    field.append(character)
                }
                index += 1
                continue
            }

            switch character {
            case "\"":
                isInsideQuotes = true
            case ",":
                row.append(field)
                field = ""
            case "\n", "\r", "\r\n":
                row.append(field)
                rows.append(row)
                row = []
                field = ""
            default:
                field.append(character)
            }

            index += 1
        }

        if !field.isEmpty || !row.isEmpty {
            row.append(field)
            rows.append(row)
        }

        return rows
    }
}
