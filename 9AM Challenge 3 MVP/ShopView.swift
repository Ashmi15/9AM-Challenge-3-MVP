//
//  ShopView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

// MARK: - Accessory model

enum AccessoryCategory: String, CaseIterable, Identifiable {
    case head
    case face
    case neck

    var id: String { rawValue }

    var title: String {
        switch self {
        case .head: return "Head"
        case .face: return "Face"
        case .neck: return "Neck"
        }
    }

    var emoji: String {
        switch self {
        case .head: return "🎩"
        case .face: return "🕶️"
        case .neck: return "🧣"
        }
    }

    // Where the accessory sits on the munchkin preview.
    var previewOffset: CGSize {
        switch self {
        case .head: return CGSize(width: 0, height: -62)
        case .face: return CGSize(width: 0, height: -18)
        case .neck: return CGSize(width: 0, height: 46)
        }
    }

    var previewSize: CGFloat {
        switch self {
        case .head: return 44
        case .face: return 32
        case .neck: return 34
        }
    }
}

struct ShopAccessory: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let price: Int
    let category: AccessoryCategory
    let about: String
    /// How many accessories the user must own before this one is revealed.
    let unlockRequirement: Int
}

enum ShopCatalogue {
    static let items: [ShopAccessory] = [
        ShopAccessory(
            id: "party_hat", name: "Party Hat", emoji: "🎩", price: 15, category: .head,
            about: "A dapper top hat for fancy food outings.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "pink_bow", name: "Pink Bow", emoji: "🎀", price: 20, category: .head,
            about: "A little sweetness with every bite.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "snack_cap", name: "Snack Cap", emoji: "🧢", price: 25, category: .head,
            about: "For casual cafe crawls and snack runs.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "royal_crown", name: "Royal Crown", emoji: "👑", price: 60, category: .head,
            about: "For the true ruler of the food court.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "foodie_specs", name: "Foodie Specs", emoji: "👓", price: 15, category: .face,
            about: "Helps you spot the best dish on the menu.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "cool_shades", name: "Cool Shades", emoji: "🕶️", price: 30, category: .face,
            about: "Too cool for bland food.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "swim_goggles", name: "Snorkel Goggles", emoji: "🥽", price: 40, category: .face,
            about: "For diving straight into the dessert menu.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "cosy_scarf", name: "Cosy Scarf", emoji: "🧣", price: 20, category: .neck,
            about: "Keeps your munchkin warm between meals.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "bead_necklace", name: "Bead Necklace", emoji: "📿", price: 35, category: .neck,
            about: "A little bling with your brunch.", unlockRequirement: 0
        ),
        ShopAccessory(
            id: "tropical_lei", name: "Tropical Lei", emoji: "🌺", price: 45, category: .neck,
            about: "Holiday vibes, even on a Tuesday lunch.", unlockRequirement: 4
        ),
        ShopAccessory(
            id: "butterfly_pin", name: "Butterfly Pin", emoji: "🦋", price: 55, category: .neck,
            about: "A flutter of colour for the fanciest foodie.", unlockRequirement: 6
        )
    ]
}

// MARK: - Shop

struct ShopView: View {
    private enum ShopTab: String, CaseIterable, Identifiable {
        case buy
        case munchkin

        var id: String { rawValue }

        var title: String {
            switch self {
            case .buy: return "Buy"
            case .munchkin: return "My Munchkin"
            }
        }
    }

    @State private var tab: ShopTab = .buy
    @State private var selectedItem: ShopAccessory?

    // Shares the coin balance with the Goals tab.
    @AppStorage("goal_currency_v1") private var coins = 0
    @AppStorage("shop_owned_v1") private var ownedRaw = ""
    @AppStorage("shop_equipped_v1") private var equippedRaw = ""

    private let backgroundColor = Color(red: 1.0, green: 0.97, blue: 0.93)
    private let mintColor = Color(red: 0.65, green: 0.89, blue: 0.75)
    private let deepGreen = Color(red: 0.2, green: 0.45, blue: 0.35)

    private let itemColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private let inventoryColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    header

                    Picker("Shop section", selection: $tab) {
                        ForEach(ShopTab.allCases) { shopTab in
                            Text(shopTab.title).tag(shopTab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.orange)

                    if tab == .buy {
                        buySection
                    } else {
                        munchkinSection
                    }
                }
                .padding(20)
            }
            .background(backgroundColor)
            .navigationBarHidden(true)
            .sheet(item: $selectedItem) { item in
                AccessoryDetailSheet(
                    item: item,
                    coins: coins,
                    owned: ownedIDs.contains(item.id),
                    wearing: equipped[item.category] == item.id,
                    unlocked: isUnlocked(item),
                    onBuy: { buy(item) },
                    onToggleWear: { toggleEquip(item) }
                )
            }
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Munchkin Shop")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Spend your goal coins on a new look!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Text("🪙 \(coins)")
                .font(.headline)
                .foregroundStyle(.orange)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.white)
                .clipShape(Capsule())
                .fixedSize()
        }
    }

    // MARK: Buy

    private var buySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Accessories")
                .font(.title2)
                .fontWeight(.bold)

            Text("Tap an accessory to see more. Anything you own can be worn from My Munchkin.")
                .font(.caption)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: itemColumns, spacing: 12) {
                ForEach(ShopCatalogue.items) { item in
                    itemTile(item)
                }
            }

            Label("Complete goals to earn more coins.", systemImage: "target")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
    }

    private func itemTile(_ item: ShopAccessory) -> some View {
        let owned = ownedIDs.contains(item.id)
        let unlocked = isUnlocked(item)
        let affordable = coins >= item.price

        return Button {
            selectedItem = item
        } label: {
            VStack(spacing: 8) {
                Text(owned || unlocked ? item.emoji : "?")
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        owned || unlocked ? Color.primary : deepGreen.opacity(0.6)
                    )
                    .frame(height: 56)

                Text(owned || unlocked ? item.name : "Mystery item")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(owned || unlocked ? Color.primary : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Group {
                    if owned {
                        Label("Owned", systemImage: "checkmark.seal.fill")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(deepGreen)
                    } else if !unlocked {
                        Label("Own \(item.unlockRequirement) items", systemImage: "lock.fill")
                            .font(.caption2)
                            .foregroundStyle(deepGreen.opacity(0.8))
                    } else {
                        Text("🪙 \(item.price)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(affordable ? Color.white : Color.black.opacity(0.35))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(affordable ? Color.orange : Color.black.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                .frame(height: 30)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .background(tileColor(for: item, unlocked: unlocked, owned: owned))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contentShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }

    private func tileColor(for item: ShopAccessory, unlocked: Bool, owned: Bool) -> Color {
        guard unlocked || owned else {
            return Color(red: 0.89, green: 0.87, blue: 0.84)
        }

        switch item.category {
        case .head: return Color(red: 0.98, green: 0.82, blue: 0.78)
        case .face: return Color(red: 0.78, green: 0.93, blue: 0.84)
        case .neck: return Color(red: 1.0, green: 0.92, blue: 0.72)
        }
    }

    // MARK: My Munchkin

    private var munchkinSection: some View {
        VStack(spacing: 16) {
            munchkinPreview

            if ownedAccessories.isEmpty {
                VStack(spacing: 10) {
                    Text("🧺")
                        .font(.system(size: 44))

                    Text("No accessories yet")
                        .font(.headline)

                    Text("Head to Buy and grab something cute for your munchkin.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                ForEach(AccessoryCategory.allCases) { category in
                    let items = ownedAccessories.filter { $0.category == category }

                    if !items.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(category.emoji) \(category.title)")
                                .font(.headline)

                            LazyVGrid(columns: inventoryColumns, spacing: 10) {
                                ForEach(items) { item in
                                    dressUpTile(item)
                                }
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
        }
    }

    private var munchkinPreview: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Your Munchkin")
                    .font(.headline)

                Spacer()

                Text("\(ownedIDs.count)/\(ShopCatalogue.items.count) owned")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(deepGreen)
            }

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.55))
                    .frame(width: 200, height: 200)

                Text("🐱")
                    .font(.system(size: 115))

                ForEach(equippedAccessories) { item in
                    Text(item.emoji)
                        .font(.system(size: item.category.previewSize))
                        .offset(item.category.previewOffset)
                        .shadow(color: .black.opacity(0.12), radius: 2, y: 1)
                }
            }
            .frame(height: 210)
            .frame(maxWidth: .infinity)

            Text(
                equippedAccessories.isEmpty
                    ? "Your munchkin is ready for a makeover!"
                    : "Tap an accessory below to wear it, or tap it again to take it off."
            )
            .font(.caption)
            .foregroundStyle(deepGreen)
            .multilineTextAlignment(.center)

            if !equippedAccessories.isEmpty {
                Button {
                    equippedRaw = ""
                } label: {
                    Text("Take everything off")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(deepGreen)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(mintColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func dressUpTile(_ item: ShopAccessory) -> some View {
        let isWearing = equipped[item.category] == item.id

        return Button {
            toggleEquip(item)
        } label: {
            VStack(spacing: 6) {
                Text(item.emoji)
                    .font(.system(size: 32))

                Text(item.name)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(isWearing ? Color.orange : Color.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isWearing ? Color.orange.opacity(0.15) : backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isWearing ? Color.orange : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.name)
        .accessibilityValue(isWearing ? "Wearing" : "Not wearing")
    }

    // MARK: Saved state

    private var ownedIDs: Set<String> {
        Set(ownedRaw.split(separator: ",").map { String($0) })
    }

    private var equipped: [AccessoryCategory: String] {
        var result: [AccessoryCategory: String] = [:]
        for pair in equippedRaw.split(separator: ",") {
            let parts = pair.split(separator: "=")
            guard parts.count == 2,
                  let category = AccessoryCategory(rawValue: String(parts[0])) else { continue }
            result[category] = String(parts[1])
        }
        return result
    }

    private var ownedAccessories: [ShopAccessory] {
        ShopCatalogue.items.filter { ownedIDs.contains($0.id) }
    }

    private var equippedAccessories: [ShopAccessory] {
        AccessoryCategory.allCases.compactMap { category in
            guard let id = equipped[category] else { return nil }
            return ShopCatalogue.items.first { $0.id == id }
        }
    }

    private func isUnlocked(_ item: ShopAccessory) -> Bool {
        item.unlockRequirement == 0 || ownedIDs.count >= item.unlockRequirement
    }

    private func buy(_ item: ShopAccessory) {
        guard !ownedIDs.contains(item.id),
              isUnlocked(item),
              coins >= item.price else { return }

        coins -= item.price

        var owned = ownedIDs
        owned.insert(item.id)
        ownedRaw = owned.sorted().joined(separator: ",")

        // Wear a new item straight away if that slot is still empty.
        if equipped[item.category] == nil {
            setEquipped(item.id, for: item.category)
        }
    }

    private func toggleEquip(_ item: ShopAccessory) {
        guard ownedIDs.contains(item.id) else { return }

        if equipped[item.category] == item.id {
            setEquipped(nil, for: item.category)
        } else {
            setEquipped(item.id, for: item.category)
        }
    }

    private func setEquipped(_ id: String?, for category: AccessoryCategory) {
        var map = equipped
        map[category] = id
        equippedRaw = map
            .map { "\($0.key.rawValue)=\($0.value)" }
            .sorted()
            .joined(separator: ",")
    }
}

// MARK: - Item details

private struct AccessoryDetailSheet: View {
    let item: ShopAccessory
    let coins: Int
    let owned: Bool
    let wearing: Bool
    let unlocked: Bool
    let onBuy: () -> Void
    let onToggleWear: () -> Void

    @Environment(\.dismiss) private var dismiss

    private let deepGreen = Color(red: 0.2, green: 0.45, blue: 0.35)
    private let cream = Color(red: 1.0, green: 0.97, blue: 0.93)

    var body: some View {
        VStack(spacing: 18) {
            Text(item.emoji)
                .font(.system(size: 76))
                .frame(width: 130, height: 130)
                .background(cream)
                .clipShape(Circle())

            VStack(spacing: 6) {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("\(item.category.emoji) \(item.category.title) accessory")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(deepGreen)

                Text(item.about)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer(minLength: 0)

            actionButton
        }
        .padding(24)
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private var actionButton: some View {
        if owned {
            Button {
                onToggleWear()
                dismiss()
            } label: {
                Label(
                    wearing ? "Take it off" : "Wear it",
                    systemImage: wearing ? "xmark.circle" : "checkmark.circle.fill"
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(Color.white)
                .background(Color.orange)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        } else if !unlocked {
            Text("Own \(item.unlockRequirement) accessories to reveal this one.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        } else {
            Button {
                onBuy()
                dismiss()
            } label: {
                Text(
                    coins >= item.price
                        ? "Buy for 🪙 \(item.price)"
                        : "Not enough coins (🪙 \(coins))"
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(Color.white)
                .background(coins >= item.price ? Color.orange : Color.black.opacity(0.2))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(coins < item.price)
        }
    }
}

#Preview {
    ShopView()
}
