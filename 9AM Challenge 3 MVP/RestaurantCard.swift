//
//  RestaurantCard.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct RestaurantCard: View {
    let restaurant: Restaurant

    var body: some View {
        HStack(spacing: 15) {
            Text(restaurant.emoji)
                .font(.dynaPuff(42))
                .frame(width: 70, height: 30)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 15))

            VStack(alignment: .leading, spacing: 5) {
                Text(restaurant.name)
                    .font(.dynaPuff(17))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(restaurant.description)
                    .font(.dynaPuff(15))
                    .foregroundStyle(AppColor.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.blue)
        }
        .padding(12)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    RestaurantCard(restaurant: .preview)
}
