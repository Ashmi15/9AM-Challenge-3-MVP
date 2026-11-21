//
//  DietaryRestaurants.swift
//  9AM Challenge 3 MVP
//
//  Curated vegan and vegetarian venues. The OpenStreetMap export that powers
//  the rest of the directory carries no dietary tags, so every entry here has
//  an explicit classification instead of relying on keyword guessing.
//
//  Classification key:
//  - VG:  fully vegan
//  - V+:  vegetarian kitchen with vegan choices
//  - V:   vegetarian only; vegan dishes are not guaranteed
//  - M+:  mixed menu (serves meat) but with dedicated vegan options
//

import Foundation

enum DietaryRestaurants {

    struct Entry {
        let name: String
        let area: String
        let cuisine: String
        let dietClass: DietClass
        let address: String
        let postcode: String
        let summary: String

        init(
            name: String,
            area: String,
            cuisine: String,
            dietClass: DietClass,
            address: String = "",
            postcode: String = "",
            summary: String = ""
        ) {
            self.name = name
            self.area = area
            self.cuisine = cuisine
            self.dietClass = dietClass
            self.address = address
            self.postcode = postcode
            self.summary = summary
        }
    }

    /// Merged into `RestaurantDirectory.all` so Explore, Weekly Recs and the
    /// Munchie Mixer can surface these venues for vegetarian and vegan users.
    static let all: [Restaurant] = entries.map { entry in
        Restaurant(
            id: "curated|\(entry.name)|\(entry.area)",
            name: entry.name,
            cuisine: entry.cuisine,
            area: entry.area,
            address: entry.address,
            postcode: entry.postcode,
            phone: "",
            website: "",
            latitude: 0,
            longitude: 0,
            isStale: false,
            dietClass: entry.dietClass,
            summary: entry.summary
        )
    }

    private static let entries: [Entry] = [
        // MARK: Fully vegan (VG)

        Entry(
            name: "nomVnom Bistro",
            area: "Clarke Quay",
            cuisine: "Vegan Burgers",
            dietClass: .vegan,
            summary: "Burgers, pizza and pasta, entirely plant-based."
        ),
        Entry(
            name: "VeganBurg",
            area: "Bugis",
            cuisine: "Vegan Burgers",
            dietClass: .vegan,
            summary: "Plant-based burgers and fries."
        ),
        Entry(
            name: "VEGANBURG Jalan Eunos",
            area: "Eunos",
            cuisine: "Vegan Burgers",
            dietClass: .vegan,
            address: "44 Jalan Eunos",
            summary: "Fully plant-based burgers, including mushroom and chilli-crab-inspired options."
        ),
        Entry(
            name: "The Kind Bowl",
            area: "Somerset",
            cuisine: "Vegan Vietnamese",
            dietClass: .vegan,
            summary: "Vietnamese pho, banh mi and rice bowls. Entirely vegan."
        ),
        Entry(
            name: "The Kind Bowl",
            area: "Yishun",
            cuisine: "Vegan Vietnamese",
            dietClass: .vegan,
            address: "930 Yishun Ave 2, B1-46 Northpoint City North Wing",
            postcode: "769098",
            summary: "Vietnamese pho, banh mi, noodles and rice bowls. A particularly clear vegan-only option in the North."
        ),
        Entry(
            name: "ahimsa sanctuary",
            area: "Tanjong Pagar",
            cuisine: "Vegan Café",
            dietClass: .vegan,
            address: "76 Neil Rd",
            postcode: "088840",
            summary: "Wellness café with plant-based bowls, bagels and creative vegan meals."
        ),
        Entry(
            name: "Cultivate",
            area: "Maxwell",
            cuisine: "Vegan Contemporary",
            dietClass: .vegan,
            address: "2 Cook Street, Maxwell Reserve",
            summary: "Upscale plant-based dining with contemporary dishes."
        ),
        Entry(
            name: "Genesis Vegan Restaurant",
            area: "Chinatown",
            cuisine: "Vegan Asian",
            dietClass: .vegan
        ),
        Entry(
            name: "Makan Vegan",
            area: "Jalan Besar",
            cuisine: "Vegan Local",
            dietClass: .vegan,
            summary: "Fully vegan local food on the central fringe."
        ),
        Entry(
            name: "Veggie 121",
            area: "Little India",
            cuisine: "Vegan Hawker",
            dietClass: .vegan
        ),
        Entry(
            name: "Fire Flies",
            area: "Chinatown",
            cuisine: "Vegan Noodles",
            dietClass: .vegan,
            address: "People's Park Centre",
            summary: "Affordable local plant-based dishes including noodles and traditional-style vegan meals."
        ),
        Entry(
            name: "YiSuPin Vegan",
            area: "Chinatown",
            cuisine: "Vegan Local",
            dietClass: .vegan,
            address: "People's Park Centre",
            summary: "Vegan local comfort food."
        ),
        Entry(
            name: "Yi Xin Vegetarian",
            area: "Chinatown",
            cuisine: "Vegan Chinese",
            dietClass: .vegan,
            address: "Temple Street",
            summary: "Reported fully vegan since November 2025."
        ),
        Entry(
            name: "Mitu Rice",
            area: "Shenton Way",
            cuisine: "Vegan Local",
            dietClass: .vegan,
            summary: "Reported fully vegan — verify the current outlet before visiting."
        ),
        Entry(
            name: "729 Vegan",
            area: "Hougang",
            cuisine: "Vegan Plant-Based",
            dietClass: .vegan
        ),
        Entry(
            name: "Lilac Oak",
            area: "Oxley Rise",
            cuisine: "Vegan Café",
            dietClass: .vegan,
            summary: "Plant-based café on the central fringe."
        ),
        Entry(
            name: "Makan Vegan 斋这里",
            area: "Punggol",
            cuisine: "Vegan Asian",
            dietClass: .vegan
        ),
        Entry(
            name: "Living Wholesome",
            area: "Bukit Timah",
            cuisine: "Vegan Hawker",
            dietClass: .vegan,
            summary: "Fully plant-based hawker stall."
        ),
        Entry(
            name: "WellSmoocht",
            area: "Jurong East",
            cuisine: "Vegan Café",
            dietClass: .vegan,
            address: "319 Jurong East Street 31, #01-58",
            summary: "Vegan pizzas, burgers, waffles, ice cream and desserts — one of the strongest vegan-only cafés in the West."
        ),

        // MARK: Vegetarian with vegan options (V+)

        Entry(
            name: "New Green Pasture Cafe",
            area: "Jalan Besar",
            cuisine: "Vegetarian Café",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Wakamama Japanese Omakase",
            area: "Tanjong Pagar",
            cuisine: "Vegetarian Japanese",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Whole Earth",
            area: "Tanjong Pagar",
            cuisine: "Vegetarian Peranakan",
            dietClass: .vegetarianWithVeganOptions,
            address: "76 Peck Seah St",
            postcode: "079331",
            summary: "Vegetarian Peranakan and Thai-inspired dishes; the menu is almost entirely vegan."
        ),
        Entry(
            name: "Eight Treasures Vegetarian Restaurant",
            area: "Chinatown",
            cuisine: "Vegetarian Chinese",
            dietClass: .vegetarianWithVeganOptions,
            address: "282A South Bridge Road, Sago Ln",
            postcode: "058831",
            summary: "Chinese vegetarian dim sum, mock-meat dishes and family-style meals, with clearly labelled vegan options."
        ),
        Entry(
            name: "Su Man Yuan Vegetarian",
            area: "Tanjong Pagar",
            cuisine: "Vegetarian Local",
            dietClass: .vegetarian,
            summary: "Vegan status is disputed — egg is reportedly used in some dishes, so please check."
        ),
        Entry(
            name: "Swaad Vegetarian",
            area: "Shenton Way",
            cuisine: "Vegetarian Indian",
            dietClass: .vegetarianWithVeganOptions,
            summary: "Indian vegetarian with vegan options."
        ),
        Entry(
            name: "Pu Xiang Vegetarian",
            area: "Chinatown",
            cuisine: "Vegetarian Chinese",
            dietClass: .vegetarianWithVeganOptions,
            address: "Chinatown Complex",
            summary: "Vegetarian Chinese with vegan options."
        ),
        Entry(
            name: "The Boneless Kitchen",
            area: "Tai Seng",
            cuisine: "Vegetarian Korean",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Warung Ijo",
            area: "Tai Seng",
            cuisine: "Vegetarian Indonesian",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Saute Saranghae",
            area: "Tampines",
            cuisine: "Vegetarian Korean",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Saute Sushi",
            area: "Paya Lebar",
            cuisine: "Vegetarian Japanese",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Greendot Paya Lebar",
            area: "Paya Lebar",
            cuisine: "Vegetarian Local",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Greendot Patisserie",
            area: "Paya Lebar",
            cuisine: "Vegan Bakery",
            dietClass: .vegetarianWithVeganOptions,
            summary: "Vegan baked goods — verify the current range."
        ),
        Entry(
            name: "elemen",
            area: "Paya Lebar",
            cuisine: "Vegetarian Asian",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Simplefood Vegetarian & Vegan Cuisine",
            area: "Kaki Bukit",
            cuisine: "Vegetarian Local",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Botanict",
            area: "Clementi",
            cuisine: "Vegetarian Peranakan",
            dietClass: .vegetarianWithVeganOptions,
            address: "352 Clementi Avenue 2",
            summary: "Peranakan-inspired meals, mala, noodles and plant-based local food."
        ),
        Entry(
            name: "iVegan",
            area: "Upper Thomson",
            cuisine: "Vegetarian Fusion",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Leaf Corner Nanyang CC Vegetarian 慈素餐馆",
            area: "Jurong West",
            cuisine: "Vegetarian Chinese",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Vegetarian Villas",
            area: "Jurong West",
            cuisine: "Vegetarian Local",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Mother Earth Vegetarian Restaurant 大地之素",
            area: "Jurong West",
            cuisine: "Vegetarian Chinese",
            dietClass: .vegetarianWithVeganOptions,
            address: "Upper Jurong Road"
        ),
        Entry(
            name: "Greendot Jurong Point",
            area: "Jurong West",
            cuisine: "Vegetarian Local",
            dietClass: .vegetarianWithVeganOptions,
            address: "Jurong Point"
        ),
        Entry(
            name: "Greendot Westgate",
            area: "Jurong East",
            cuisine: "Vegetarian Local",
            dietClass: .vegetarianWithVeganOptions,
            address: "Westgate"
        ),
        Entry(
            name: "Nature Vegetarian Delights",
            area: "Bukit Batok",
            cuisine: "Vegetarian Chinese",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Green on Earth",
            area: "Upper Bukit Timah",
            cuisine: "Vegetarian Local",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "D'Life",
            area: "Beauty World",
            cuisine: "Vegetarian Local",
            dietClass: .vegetarianWithVeganOptions,
            address: "Beauty World"
        ),
        Entry(
            name: "Original Sin",
            area: "Holland Village",
            cuisine: "Vegetarian Mediterranean",
            dietClass: .vegetarianWithVeganOptions
        ),
        Entry(
            name: "Sunnychoice Vegan Cafe and Healthy Option Store",
            area: "Bukit Batok",
            cuisine: "Vegan Café",
            dietClass: .vegetarianWithVeganOptions,
            summary: "Vegan café and health store — confirm the whole menu is vegan."
        ),

        // MARK: Pure vegetarian Indian (V / V+)

        Entry(name: "Kailash Parbat", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Nalan Restaurant", area: "City Hall", cuisine: "Vegetarian Indian", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Komala Vilas", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Saravanaa Bhavan", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Ananda Bhavan", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "MTR Singapore", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Annalakshmi Restaurant", area: "Shenton Way", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Annapoorna Original Pure Vegetarian", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Gokul Raas", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Shivam Restaurant", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Swaad Art of Saatvik Food", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Bikanervala", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "A2B Vegetarian Restaurant", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Murugan Idli Shop", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Madras New Woodlands", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Madras Woodlands Ganga", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Podi & Poriyal", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Sattvik Indian Vegetarian Restaurant", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Udipi Ganesh Vilas (Tanjong Pagar)", area: "Tanjong Pagar", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Udipi Ganesh Vilas (Katong)", area: "Joo Chiat", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Ragunath Restaurant", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Sampoorna Swadesi Vegetarian Restaurant", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Aarya Pure Veg Restaurant", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Arunachala Bhavan", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Ballaji Bhawan", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Bangalore Cafe", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Bazil Kitchen", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Santhi Vilas", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Poona Punjabi Dhaba", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Chandra Mahal", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Cow & Farmer", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),
        Entry(name: "Arputha Vilas", area: "Little India", cuisine: "Vegetarian Indian", dietClass: .vegetarian),

        // MARK: Chinese, Taiwanese and local vegetarian (V / V+)

        Entry(name: "LingZhi Greens", area: "Orchard", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Sufood", area: "City Hall", cuisine: "Vegetarian Taiwanese", dietClass: .vegetarian),
        Entry(name: "Greendot", area: "Bugis", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Lotus Vegetarian Restaurant", area: "Chinatown", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "D'life Signature", area: "Chinatown", cuisine: "Vegetarian Chinese", dietClass: .vegetarian, address: "Chinatown Point"),
        Entry(name: "Ascend Vegetarian 18 Cross", area: "City Hall", cuisine: "Vegetarian Fusion", dietClass: .vegetarian, address: "18 Cross Street"),
        Entry(name: "Coco Veggie Nyonya", area: "City Hall", cuisine: "Vegetarian Nyonya", dietClass: .vegetarian),
        Entry(name: "Flavours by Saute", area: "City Hall", cuisine: "Vegetarian Fusion", dietClass: .vegetarian),
        Entry(name: "Saute-san", area: "Farrer Park", cuisine: "Vegetarian Asian", dietClass: .vegetarian),
        Entry(name: "Nature Cafe", area: "Bukit Timah", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Nature Vegetarian Cuisine", area: "Telok Blangah", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "New Fut Kai Vegetarian Restaurant", area: "Jalan Besar", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Yes Natural Restaurant", area: "Geylang", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Eco-Harmony Retail and Cafe", area: "Geylang", cuisine: "Vegetarian Organic", dietClass: .vegetarian),
        Entry(name: "Kang Su Vegetarian", area: "Geylang", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Kale by KangSu", area: "City Hall", cuisine: "Vegetarian Modern", dietClass: .vegetarian),
        Entry(name: "Din Shan Vegetarian", area: "Tiong Bahru", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Mother Earth Classic Vegetarian", area: "Balestier", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Greenland Vegetarian Restaurant", area: "Kovan", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(
            name: "Leaf Corner Sembawang Vegetarian 慈素餐馆",
            area: "Sembawang",
            cuisine: "Vegetarian Chinese",
            dietClass: .vegetarianWithVeganOptions,
            address: "5 Jln Legundi",
            postcode: "759269",
            summary: "Vegetarian Chinese zi char, claypot dishes, mock meats and local food."
        ),
        Entry(name: "Lucky Cat Vegetarian Cafe", area: "Hougang", cuisine: "Vegetarian Café", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Lian Xin Vegetarian Food Court", area: "Chinatown", cuisine: "Vegetarian Chinese", dietClass: .vegetarian, address: "Buddha Tooth Relic Temple"),
        Entry(name: "Kwan Tzi Zhai Vegetarian Cuisine", area: "Geylang", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Original Greens", area: "Balestier", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Joie by Dozo", area: "Orchard", cuisine: "Vegetarian Contemporary", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Ki Su Shoujin Omakase", area: "Tanjong Pagar", cuisine: "Vegetarian Japanese", dietClass: .vegetarian),
        Entry(name: "Herbivore", area: "Bugis", cuisine: "Vegetarian Japanese", dietClass: .vegetarian),

        // MARK: Korean, Japanese, Vietnamese, Indonesian and Mediterranean (V / V+)

        Entry(name: "DAEHWA", area: "Tanjong Pagar", cuisine: "Vegetarian Korean", dietClass: .vegetarian),
        Entry(name: "Moon Chay Vegetarian", area: "Chinatown", cuisine: "Vegetarian Vietnamese", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Annam Vietnamese Vegetarian", area: "City Hall", cuisine: "Vegetarian Vietnamese", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Vege Thai Restaurant", area: "City Hall", cuisine: "Vegetarian Thai", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Teenoy Thai Vegetarian", area: "Little India", cuisine: "Vegetarian Thai", dietClass: .vegetarian),
        Entry(name: "Padma Veg Restaurant", area: "Little India", cuisine: "Vegetarian Asian", dietClass: .vegetarian),

        // MARK: North Singapore

        Entry(
            name: "Real Food Yishun",
            area: "Yishun",
            cuisine: "Vegetarian Café",
            dietClass: .vegetarianWithVeganOptions,
            address: "30A Yishun Central 1, #01-09",
            postcode: "768796",
            summary: "Vegetarian café serving pasta, burgers, Asian dishes, desserts and clearly identified vegan choices."
        ),
        Entry(name: "Greendot Northpoint", area: "Yishun", cuisine: "Vegetarian Local", dietClass: .vegetarianWithVeganOptions, address: "Northpoint City"),
        Entry(name: "Rathana Bhavan", area: "Yishun", cuisine: "Vegetarian Indian", dietClass: .vegetarianWithVeganOptions, address: "Northpoint City"),
        Entry(name: "Zi Zai Vegetarian", area: "Yishun", cuisine: "Vegetarian Chinese", dietClass: .vegetarianWithVeganOptions, address: "Yishun Ring Road"),
        Entry(name: "SHU Vegetarian", area: "Woodlands", cuisine: "Vegetarian Chinese", dietClass: .vegetarianWithVeganOptions, address: "Woodlands Avenue 1"),
        Entry(name: "Vege Story", area: "Woodlands", cuisine: "Vegetarian Local", dietClass: .vegetarianWithVeganOptions, address: "Woodlands Drive 50"),
        Entry(name: "Tanaka Vegetarian Food 田中素食 @ 兀兰", area: "Woodlands", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "Woodlands Street 31"),
        Entry(name: "Vegetarian Kitchen by Daily Green", area: "Woodlands", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "Woodlands Street 31", summary: "Vegetarian stall — request no egg or dairy."),
        Entry(name: "Zhen Xiang Vegetarian", area: "Woodlands", cuisine: "Vegetarian Chinese", dietClass: .vegetarian, address: "Woodlands Street 32"),
        Entry(name: "En Hui Vegetarian Food", area: "Marsiling", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "Marsiling Mall", summary: "Vegetarian local food — request no egg."),
        Entry(name: "Yi Shou Vegetarian", area: "Yishun", cuisine: "Vegetarian Local", dietClass: .vegetarianWithVeganOptions, address: "Yishun Street 61"),
        Entry(name: "Fu Kang Vegetarian", area: "Yishun", cuisine: "Vegetarian Local", dietClass: .vegetarianWithVeganOptions, address: "Yishun Street 81"),
        Entry(name: "Just Greens", area: "Yishun", cuisine: "Vegetarian Chinese", dietClass: .vegetarianWithVeganOptions, address: "Yishun Ave 11"),
        Entry(name: "Hao Yuan Vegetarian", area: "Yishun", cuisine: "Vegetarian Chinese", dietClass: .vegetarian, address: "Yishun Street 22"),
        Entry(name: "Tree Top Vegetarian", area: "Yishun", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "Yishun Avenue 2"),
        Entry(name: "Fu Gui Su Shi", area: "Woodlands", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "Woodlands Avenue 2"),
        Entry(name: "真一素食坊 Zhenyi Veggie Place", area: "Ang Mo Kio", cuisine: "Vegetarian Chinese", dietClass: .vegetarian, address: "Ang Mo Kio Avenue 3"),
        Entry(name: "AMK Vegetarian Corner", area: "Ang Mo Kio", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "Ang Mo Kio Avenue 10"),
        Entry(name: "Kin Veg Stall", area: "Ang Mo Kio", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "Ang Mo Kio Avenue 4"),
        Entry(name: "Nature Veggie Food", area: "Ang Mo Kio", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "AMK Hub"),
        Entry(name: "Green Dot AMK", area: "Ang Mo Kio", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "AMK Hub"),
        Entry(name: "Sanook Kitchen", area: "Woodlands", cuisine: "Thai", dietClass: .mixedWithVeganOptions, summary: "Mixed menu with vegan options."),

        // MARK: South Singapore
        // Tanjong Pagar and Chinatown are part of the app's Central region;
        // HarbourFront / VivoCity sit in the South region.

        Entry(name: "Yuki Duyen Chay", area: "Chinatown", cuisine: "Vegetarian Vietnamese", dietClass: .vegetarian),
        Entry(name: "Tong Xin Vegetarian", area: "Alexandra", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Padi Rice", area: "Pasir Panjang", cuisine: "Vegetarian Local", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "E veg vegetarian", area: "HarbourFront", cuisine: "Vegetarian Local", dietClass: .vegetarian, address: "VivoCity"),
        Entry(name: "Greendot VivoCity", area: "HarbourFront", cuisine: "Vegetarian Local", dietClass: .vegetarianWithVeganOptions, address: "VivoCity"),
        Entry(name: "The Alignment Cafe", area: "Tanjong Pagar", cuisine: "Vegetarian Café", dietClass: .vegetarianWithVeganOptions),
        Entry(name: "Bai Wei Vegetarian", area: "Chinatown", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Healthy Vegetarian Food", area: "Chinatown", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Su Xiang Chinese Vegetarian Cuisine", area: "Chinatown", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Vegetarian Cooked Food", area: "Chinatown", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "3WAY Soul Cafe", area: "Chinatown", cuisine: "Vegetarian Café", dietClass: .vegetarian),
        Entry(name: "Hao Xiang Ju Cooked Food", area: "Chinatown", cuisine: "Vegetarian Local", dietClass: .vegetarian),

        // MARK: East Singapore

        Entry(name: "A Cup of Time Vegetarian", area: "Bedok", cuisine: "Vegetarian Café", dietClass: .vegetarian, summary: "Vegetarian café — check which dishes are vegan."),
        Entry(name: "IM QALB by Pun Im", area: "Tampines", cuisine: "Thai", dietClass: .mixedWithVeganOptions, summary: "Mixed menu with a substantial vegan selection, including Massaman curry and vegan khao soi."),
        Entry(name: "Sanook Kitchen", area: "Paya Lebar", cuisine: "Thai", dietClass: .mixedWithVeganOptions, summary: "Mixed menu with vegan options."),
        Entry(name: "Cedele", area: "Paya Lebar", cuisine: "Café", dietClass: .mixedWithVeganOptions, summary: "Mixed menu with vegan options."),

        // MARK: Neighbourhood vegetarian eateries
        // Areas are not published for these smaller stalls, so they are listed
        // under Singapore and surface through the Central region.

        Entry(name: "B Friend Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Beng Shun Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Bishan Vegetarian Stall", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Chee Wei Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Ci Yan Organic Vegetarian", area: "Singapore", cuisine: "Vegetarian Organic", dietClass: .vegetarian),
        Entry(name: "Cundhi Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Divine Realm Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Divine Vegetarian Family Restaurant", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Eight Immortals Vegetarian", area: "Singapore", cuisine: "Vegetarian Chinese", dietClass: .vegetarian),
        Entry(name: "Fei Cui Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Foy Yin Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Fu Kang Ting Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Gan En Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Good Earth Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "He Hua Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Hup Seng Heng Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Ji Xiang Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Jin You Yuan Healthy Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Le Le Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Mei Jing Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Miao Cheng Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "New Zai Xing Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Onn Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Organics Vegetarian", area: "Singapore", cuisine: "Vegetarian Organic", dietClass: .vegetarian),
        Entry(name: "Origanics Vegetarian", area: "Singapore", cuisine: "Vegetarian Organic", dietClass: .vegetarian),
        Entry(name: "Pure Heart Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Ru Yi Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Ruyi Yuan Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "San Yuan Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Su Shi Piao Xiang", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Sunny Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Supreme Vege", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Tian En Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Tian Yi Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Tian Yuan Healthy Vegetarian Food Paradise", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Uniquely Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Vegetarian Delight", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Verimix Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Wan Fu Shi Jie Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Xing Hua Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Yi Lian Vegetarian Food", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Yuan Xiang Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Zhen Xin Su Shi Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
        Entry(name: "Zuya Vegetarian", area: "Singapore", cuisine: "Vegetarian Local", dietClass: .vegetarian),
    ]
}
