//
//  RegionFilterBar.swift
//  9AM Challenge 3 MVP
//
//  Shared region filter used across recommendations and the mixer.
//

import SwiftUI

struct RegionFilterBar: View {
    @Binding var selection: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(RestaurantRegion.allCases) { region in
                    let isSelected = selection == region.rawValue

                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selection = region.rawValue
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(
                                systemName: region.isAnywhere
                                    ? "globe.asia.australia.fill"
                                    : "mappin.circle.fill"
                            )
                            .font(.caption)

                            Text(region.rawValue)
                        }
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .foregroundStyle(
                            isSelected
                                ? Color.white
                                : Color(red: 0.75, green: 0.38, blue: 0.05)
                        )
                        .background(
                            isSelected ? Color.orange : Color.white
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.orange.opacity(0.35), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Filter by \(region.rawValue)")
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
            .padding(.vertical, 2)
        }
    }
}

#Preview {
    RegionFilterBar(selection: .constant("Central"))
        .padding()
        .background(Color(red: 1.0, green: 0.97, blue: 0.93))
}
