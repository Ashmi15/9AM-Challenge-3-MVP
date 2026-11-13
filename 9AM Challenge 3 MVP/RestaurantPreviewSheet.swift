//
//  RestaurantPreviewSheet.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//


import SwiftUI

struct RestaurantPreviewSheet: View {

    let emoji: String
    let name: String
    let description: String
    let reason: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Restaurant information
            HStack(spacing: 15) {
                Text(emoji)
                    .font(.system(size: 65))
                    .frame(width: 100, height: 100)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 8) {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Label("Budget-friendly", systemImage: "dollarsign.circle")
                        .font(.caption)
                }
            }

            Divider()

            Text("A little taste of what's waiting for you!")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer(minLength: 0)

            // Mascot explanation in bottom-right
            HStack(alignment: .bottom, spacing: 10) {
                Text(reason)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Text("🐱")
                    .font(.system(size: 45))
            }

            Button {
                // We'll connect the full details page next.
            } label: {
                Text("View Full Details →")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .padding(20)
        .background(Color(red: 1.0, green: 0.97, blue: 0.93))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    RestaurantPreviewSheet(
        emoji: "🍜",
        name: "Mala Hotpot",
        description: "Spicy • Chinatown",
        reason: "You love spicy food, so I thought you'd enjoy this!"
    )
}

