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
        // One-time data fixes must land before any tab reads UserDefaults.
        GoalRewardRepair.runIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
