//
//  MunchkinAvatarView.swift
//  9AM Challenge 3 MVP
//
//  One dressed-up munchkin, reused everywhere the pet appears so accessories
//  bought in the shop travel with it across the whole app.
//

import SwiftUI

/// Reads the accessories the user equipped in the Munchkin Shop.
enum MunchkinOutfit {
    static let equippedKey = "shop_equipped_v1"

    static func decode(_ raw: String?) -> [AccessoryCategory: String] {
        var result: [AccessoryCategory: String] = [:]
        for pair in (raw ?? "").split(separator: ",") {
            let parts = pair.split(separator: "=")
            guard parts.count == 2,
                  let category = AccessoryCategory(rawValue: String(parts[0])) else { continue }
            result[category] = String(parts[1])
        }
        return result
    }

    static func accessories(from raw: String?) -> [ShopAccessory] {
        let equippedIDs = Set(decode(raw).values)
        return ShopCatalogue.items.filter { equippedIDs.contains($0.id) }
    }
}

/// The current pet wearing whatever the user has dressed it in.
struct MunchkinAvatarView: View {
    let persona: FoodPersona?
    let size: CGFloat
    var showAccessories: Bool = true

    @AppStorage(MunchkinOutfit.equippedKey) private var equippedRaw = ""

    init(persona: FoodPersona? = nil, size: CGFloat = 60, showAccessories: Bool = true) {
        self.persona = persona
        self.size = size
        self.showAccessories = showAccessories
    }

    private var displayedPersona: FoodPersona {
        persona ?? FoodPersonaStore.resolve().persona
    }

    /// Accessory offsets and sizes in the catalogue were tuned against the
    /// 115pt munchkin in the shop, so everything scales with the avatar.
    private var scale: CGFloat { size / 115 }

    var body: some View {
        ZStack {
            Text(displayedPersona.emoji)
                .font(.dynaPuff(size))

            if showAccessories {
                ForEach(MunchkinOutfit.accessories(from: equippedRaw)) { item in
                    Text(item.emoji)
                        .font(.dynaPuff(max(8, item.previewSize * scale)))
                        .offset(CGSize(
                            width: item.previewOffset.width * scale,
                            height: item.previewOffset.height * scale
                        ))
                        .shadow(color: .black.opacity(0.12), radius: 2 * scale, y: scale)
                }
            }
        }
        .accessibilityLabel("\(displayedPersona.name) munchkin")
    }
}

#Preview {
    VStack(spacing: 30) {
        MunchkinAvatarView(size: 115)
        MunchkinAvatarView(persona: .cookie, size: 65)
        MunchkinAvatarView(size: 32)
    }
}
