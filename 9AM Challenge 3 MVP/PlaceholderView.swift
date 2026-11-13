//
//  PlaceholderView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct PlaceholderView: View {
    let title: String
    let emoji: String

    var body: some View {
        VStack(spacing: 20) {
            Text(emoji)
                .font(.system(size: 80))

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Coming soon!")
                .foregroundStyle(.secondary)
        }
    }
}
#Preview {
    PlaceholderView(title: "title", emoji: "emoji")
}
