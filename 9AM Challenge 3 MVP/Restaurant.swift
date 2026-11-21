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
            "Fernvale", "Kebun Baru", "Lentor", "North Region",
            "North-east Region", "Sembawang", "Simpang", "Thomson",
            "Woodlands", "Yishun"
        ]),
        (.south, [
            "Fort Siloso", "HarbourFront", "Sentosa Cove", "Southern Islands"
        ]),
        (.east, [
            "Bedok", "Bedok South", "Chai Chee", "Changi",
            "Changi Business Park", "Changi Village", "Compassvale",
            "East Region", "Eunos", "Geylang", "Hougang", "Joo Chiat",
            "Kaki Bukit", "Marine Parade", "Pasir Ris", "Punggol",
            "Sengkang", "Tai Seng", "Tampines", "Telok Kurau"
        ]),
        (.west, [
            "Bukit Batok", "Bukit Gombak", "Bukit Panjang", "Choa Chu Kang",
            "Clementi", "Jurong East", "Jurong West", "Marsiling",
            "Neo Tiew Estate", "Pioneer", "Queenstown", "Sungei Kadut",
            "Tengah", "Ulu Pandan", "Upper Bukit Timah", "West Region",
            "Yew Tee", "Yuhua"
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

    /// True when this restaurant CSV entry also appears in the MUIS halal list.
    let isHalalCertified: Bool

    init(
        id: String,
        name: String,
        cuisine: String,
        area: String,
        address: String,
        postcode: String,
        phone: String,
        website: String,
        latitude: Double,
        longitude: Double,
        isStale: Bool,
        isHalalCertified: Bool = false
    ) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.area = area
        self.address = address
        self.postcode = postcode
        self.phone = phone
        self.website = website
        self.latitude = latitude
        self.longitude = longitude
        self.isStale = isStale
        self.isHalalCertified = isHalalCertified
    }

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
    /// Every restaurant in the CSV that has a name, cuisine, and area.
    static let all: [Restaurant] = loadRestaurants()

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

        // With Halal selected, only MUIS-verified establishments are eligible.
        var candidates = restaurants(in: region, halalOnly: preferences?.halal == true)
        if let preferences, !preferences.isEmpty {
            candidates = candidates.filter {
                $0.dietAdherence(for: preferences).adheresToAll
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
                        .caseInsensitiveCompare("yes") == .orderedSame,
                    isHalalCertified: isHalalListed(
                        name: name,
                        postcode: postcode,
                        address: address
                    )
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

// MARK: - Halal verification

extension RestaurantDirectory {
    /// Restaurants from the bundled restaurant CSV that also appear in the
    /// MUIS halal list. No records are added from the halal CSV itself.
    static let verifiedHalal: [Restaurant] = all.filter { $0.isHalalCertified }

    /// Restaurants in a region, from either the full directory or the halal subset.
    static func restaurants(in region: RestaurantRegion, halalOnly: Bool) -> [Restaurant] {
        let source = halalOnly ? verifiedHalal : all
        guard !region.isAnywhere else { return source }
        return source.filter { $0.region == region }
    }

    /// Weekly picks drawn from the requested directory.
    static func weeklyPicks(for region: RestaurantRegion, halalOnly: Bool) -> [Restaurant] {
        guard halalOnly else { return weeklyPicks(for: region) }
        return makeWeeklyRecommendations(from: restaurants(in: region, halalOnly: true))
    }

    /// The halal CSV is used purely as a lookup: normalised name -> records.
    private static let halalIndex: [String: [(postcode: String, tokens: Set<String>)]] = loadHalalIndex()

    /// Matches a restaurant CSV row against the MUIS list by name. The postcode
    /// (or street tokens when the CSV has no postcode) disambiguates branches
    /// that share a name.
    static func isHalalListed(name: String, postcode: String, address: String) -> Bool {
        guard let records = halalIndex[normalizedName(name)], !records.isEmpty else {
            return false
        }
        let postcode = postcode.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !postcode.isEmpty else { return true }

        if records.contains(where: { $0.postcode == postcode }) { return true }

        let tokens = addressTokens(address)
        return records.contains { !$0.tokens.isDisjoint(with: tokens) }
    }

    private static func loadHalalIndex() -> [String: [(postcode: String, tokens: Set<String>)]] {
        guard let url = Bundle.main.url(
            forResource: "halal_establishments",
            withExtension: "csv"
        ),
        let rawText = try? String(contentsOf: url, encoding: .utf8) else {
            return [:]
        }

        var text = rawText
        if text.first == "\u{FEFF}" {
            text.removeFirst()
        }

        let rows = parseCSV(text)
        guard let header = rows.first else { return [:] }

        let columnIndexes = Dictionary(
            uniqueKeysWithValues: header.enumerated().map {
                ($0.element.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), $0.offset)
            }
        )

        func value(_ row: [String], _ column: String) -> String {
            guard let index = columnIndexes[column], index < row.count else {
                return ""
            }
            return row[index].trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var index: [String: [(postcode: String, tokens: Set<String>)]] = [:]
        for row in rows.dropFirst() {
            guard value(row, "scheme").caseInsensitiveCompare("Eating Establishment") == .orderedSame else {
                continue
            }
            let name = value(row, "name")
            guard !name.isEmpty else { continue }
            let address = value(row, "address")
            index[normalizedName(name), default: []].append(
                (postcode: halalPostcode(in: address), tokens: addressTokens(address))
            )
        }
        return index
    }

    private static func normalizedName(_ name: String) -> String {
        var result = ""
        var lastWasSeparator = true
        for character in name.lowercased() {
            if character.isLetter || character.isNumber {
                result.append(character)
                lastWasSeparator = false
            } else if !lastWasSeparator {
                result.append(" ")
                lastWasSeparator = true
            }
        }
        return result.trimmingCharacters(in: .whitespaces)
    }

    private static func addressTokens(_ address: String) -> Set<String> {
        let ignored: Set<String> = [
            "road", "street", "avenue", "singapore", "restaurant",
            "coffee", "shopping", "centre", "center"
        ]
        return Set(
            address.lowercased()
                .split(whereSeparator: { !$0.isLetter })
                .map(String.init)
                .filter { $0.count >= 4 && !ignored.contains($0) }
        )
    }

    /// Last six-digit number in a halal address is the Singapore postcode.
    private static func halalPostcode(in address: String) -> String {
        address
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .last { $0.count == 6 } ?? ""
    }
}
