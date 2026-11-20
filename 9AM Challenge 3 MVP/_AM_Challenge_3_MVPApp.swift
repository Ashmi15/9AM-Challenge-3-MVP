//
//  _AM_Challenge_3_MVPApp.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

@main
struct _AM_Challenge_3_MVPApp: App {
    init() {
        // The font must be registered before any view resolves a Font.
        registerBundledDynaPuffFont()
        // Nav titles are UIKit-owned, so apply DynaPuff to the bar too.
        configureDynaPuffNavigationBar()
        // One-time data fixes must land before any tab reads UserDefaults.
        GoalRewardRepair.runIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            // Base font for any text that doesn't set one explicitly.
            ContentView()
                .font(.dynaPuff(DynaPuffFont.Size.body))
        }
    }
}
