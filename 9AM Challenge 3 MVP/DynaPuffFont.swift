//
//  DynaPuffFont.swift
//  9AM Challenge 3 MVP
//
//  DynaPuff is bundled with the app and registered at launch. Every text style
//  maps to it so the whole UI shares one playful voice.
//

import SwiftUI
import CoreText
import UIKit

/// Registers the bundled font at launch. This makes DynaPuff available even if
/// the generated Info.plist does not pick up the UIAppFonts build setting.
func registerBundledDynaPuffFont() {
    guard let url = Bundle.main.url(forResource: "DynaPuff-Regular", withExtension: "ttf")
    else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
}

/// Navigation titles are drawn by UIKit, so SwiftUI's `.font` modifier does
/// not reach them. Set the font on the navigation bar itself instead; this
/// covers "Hello Munchkin!" and every other title in the app.
func configureDynaPuffNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithDefaultBackground()

    let regular = UIFont(name: DynaPuffFont.name, size: 17)
        ?? UIFont.systemFont(ofSize: 17)
    let large = UIFont(name: DynaPuffFont.name, size: 34)
        ?? UIFont.systemFont(ofSize: 34)

    appearance.titleTextAttributes = [.font: regular]
    appearance.largeTitleTextAttributes = [.font: large]

    let navBar = UINavigationBar.appearance()
    navBar.standardAppearance = appearance
    navBar.scrollEdgeAppearance = appearance
    navBar.compactAppearance = appearance
}

enum DynaPuffFont {
    /// PostScript name of the bundled DynaPuff-Regular.ttf.
    static let name = "DynaPuff-Regular"

    /// DynaPuff is a variable font; these are the point sizes used to replace
    /// SwiftUI's default text styles.
    enum Size {
        static let caption2: CGFloat = 11
        static let caption: CGFloat = 13
        static let subheadline: CGFloat = 15
        static let body: CGFloat = 17
        static let headline: CGFloat = 17
        static let title3: CGFloat = 20
        static let title2: CGFloat = 22
        static let title: CGFloat = 28
        static let largeTitle: CGFloat = 34
    }
}

extension Font {
    /// The one font used everywhere in Munchkins. Sizes still follow Dynamic
    /// Type by anchoring each one to its closest SwiftUI text style.
    static func dynaPuff(_ size: CGFloat) -> Font {
        let base: Font.TextStyle
        switch size {
        case ..<12:  base = .caption2
        case ..<14:  base = .caption
        case ..<16:  base = .subheadline
        case ..<18:  base = .body
        case ..<21:  base = .title3
        case ..<25:  base = .title2
        case ..<31:  base = .title
        default:     base = .largeTitle
        }
        return .custom(DynaPuffFont.name, size: size, relativeTo: base)
    }
}
