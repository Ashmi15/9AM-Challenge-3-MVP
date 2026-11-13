//
//  GoalProgressRow.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct GoalProgressRow: View {
        let title: String
        let progress: Int
        let total: Int

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.subheadline)

                    Spacer()

                    Text("\(progress)/\(total)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                ProgressView(
                    value: Double(progress),
                    total: Double(total)
                )
                .tint(.orange)
            }
        }
    }
