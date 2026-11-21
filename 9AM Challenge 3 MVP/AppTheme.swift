//
//  AppTheme.swift
//  9AM Challenge 3 MVP
//
//  Adaptive colours for the app's light and dark appearances. These resolve
//  from the current colour scheme, so switching the appearance updates every
//  surface without any view needing to read the preference itself.
//

import SwiftUI

enum AppColor {
    /// Secondary text. Brighter than the system grey so it stays readable on
    /// dark cards, and a little darker than system grey in light mode.
    static let secondaryText = adaptive(
        light: UIColor(red: 0.38, green: 0.38, blue: 0.42, alpha: 1),
        dark: UIColor(red: 0.84, green: 0.86, blue: 0.90, alpha: 1)
    )

    /// Main page background (cream in light mode, deep charcoal in dark).
    static let background = adaptive(
        light: UIColor(red: 1.00, green: 0.97, blue: 0.93, alpha: 1),
        dark: UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1)
    )

    /// Cards, search fields and other raised white surfaces.
    static let card = adaptive(
        light: .white,
        dark: UIColor(red: 0.17, green: 0.18, blue: 0.21, alpha: 1)
    )

    /// Slightly lighter surface for nested panels inside dark cards.
    static let cardRaised = adaptive(
        light: UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1),
        dark: UIColor(red: 0.23, green: 0.24, blue: 0.28, alpha: 1)
    )

    /// Profile tab background (pale mint / deep green-black).
    static let profileBackground = adaptive(
        light: UIColor(red: 0.95, green: 0.98, blue: 0.96, alpha: 1),
        dark: UIColor(red: 0.09, green: 0.13, blue: 0.12, alpha: 1)
    )

    /// Home's lavender goals card.
    static let lavender = adaptive(
        light: UIColor(red: 0.90, green: 0.89, blue: 0.97, alpha: 1),
        dark: UIColor(red: 0.19, green: 0.18, blue: 0.27, alpha: 1)
    )

    /// Home's peach weekly card.
    static let peach = adaptive(
        light: UIColor(red: 1.00, green: 0.93, blue: 0.79, alpha: 1),
        dark: UIColor(red: 0.27, green: 0.22, blue: 0.16, alpha: 1)
    )

    /// Mint information panels (soft mint / deep muted green).
    static let mintPanel = adaptive(
        light: UIColor(red: 0.00, green: 0.78, blue: 0.74, alpha: 0.20),
        dark: UIColor(red: 0.14, green: 0.25, blue: 0.20, alpha: 1)
    )

    /// Text on unselected region-filter pills (dark brown / pale cream).
    static let filterText = adaptive(
        light: UIColor(red: 0.75, green: 0.38, blue: 0.05, alpha: 1),
        dark: UIColor(red: 0.95, green: 0.90, blue: 0.82, alpha: 1)
    )

    /// Dark-green message text shown on mint panels.
    static let greenInk = adaptive(
        light: UIColor(red: 0.20, green: 0.45, blue: 0.35, alpha: 1),
        dark: UIColor(red: 0.68, green: 0.90, blue: 0.76, alpha: 1)
    )

    /// Food-persona accent panels (pastel / deep muted tone so their text
    /// remains readable when the app is dark).
    static let personaMunchkin = adaptive(
        light: UIColor(red: 0.95, green: 0.75, blue: 0.73, alpha: 1),
        dark: UIColor(red: 0.32, green: 0.20, blue: 0.20, alpha: 1)
    )

    static let personaCookie = adaptive(
        light: UIColor(red: 1.00, green: 0.90, blue: 0.72, alpha: 1),
        dark: UIColor(red: 0.33, green: 0.28, blue: 0.17, alpha: 1)
    )

    static let personaFiery = adaptive(
        light: UIColor(red: 1.00, green: 0.79, blue: 0.68, alpha: 1),
        dark: UIColor(red: 0.36, green: 0.22, blue: 0.17, alpha: 1)
    )

    static let personaPanda = adaptive(
        light: UIColor(red: 1.00, green: 0.93, blue: 0.70, alpha: 1),
        dark: UIColor(red: 0.33, green: 0.30, blue: 0.18, alpha: 1)
    )

    static let personaTerry = adaptive(
        light: UIColor(red: 0.82, green: 0.88, blue: 0.99, alpha: 1),
        dark: UIColor(red: 0.20, green: 0.24, blue: 0.36, alpha: 1)
    )

    /// Shop's mint "My Munchkin" panel.
    static let shopMint = adaptive(
        light: UIColor(red: 0.65, green: 0.89, blue: 0.75, alpha: 1),
        dark: UIColor(red: 0.12, green: 0.26, blue: 0.20, alpha: 1)
    )

    /// Solid green used behind white button labels. Kept dark in both schemes.
    static let buttonGreen = adaptive(
        light: UIColor(red: 0.20, green: 0.45, blue: 0.35, alpha: 1),
        dark: UIColor(red: 0.16, green: 0.38, blue: 0.28, alpha: 1)
    )

    /// Shop accessory tile backgrounds.
    static let shopLockedTile = adaptive(
        light: UIColor(red: 0.89, green: 0.87, blue: 0.84, alpha: 1),
        dark: UIColor(red: 0.22, green: 0.23, blue: 0.26, alpha: 1)
    )

    static let shopHeadTile = adaptive(
        light: UIColor(red: 0.98, green: 0.82, blue: 0.78, alpha: 1),
        dark: UIColor(red: 0.33, green: 0.21, blue: 0.21, alpha: 1)
    )

    static let shopFaceTile = adaptive(
        light: UIColor(red: 0.78, green: 0.93, blue: 0.84, alpha: 1),
        dark: UIColor(red: 0.17, green: 0.30, blue: 0.23, alpha: 1)
    )

    static let shopNeckTile = adaptive(
        light: UIColor(red: 1.00, green: 0.92, blue: 0.72, alpha: 1),
        dark: UIColor(red: 0.33, green: 0.28, blue: 0.17, alpha: 1)
    )

    static let shopExtraTile = adaptive(
        light: UIColor(red: 0.90, green: 0.85, blue: 0.97, alpha: 1),
        dark: UIColor(red: 0.27, green: 0.22, blue: 0.34, alpha: 1)
    )

    /// Disabled / muted button label on pastel tiles.
    static let mutedInk = adaptive(
        light: UIColor.black.withAlphaComponent(0.35),
        dark: UIColor.white.withAlphaComponent(0.45)
    )

    private static func adaptive(light: UIColor, dark: UIColor) -> Color {
        Color(
            uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark ? dark : light
            }
        )
    }
}

/// Appearance setting shared by Profile and the app root. The default follows
/// whatever the device is set to; Light and Dark are optional overrides.
enum AppAppearance {
    static let storageKey = "appearance_mode_v1"

    static let device = "device"
    static let light = "light"
    static let dark = "dark"

    static let options = [device, light, dark]

    static func label(for mode: String) -> String {
        switch mode {
        case light: return "Light"
        case dark: return "Dark"
        default: return "Device"
        }
    }

    /// `nil` means "follow the device"; SwiftUI then keeps the system scheme.
    static func colorScheme(for mode: String) -> ColorScheme? {
        switch mode {
        case light: return .light
        case dark: return .dark
        default: return nil
        }
    }
}
