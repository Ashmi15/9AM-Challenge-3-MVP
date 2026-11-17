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
    var completed: Bool = false
    var reward: Int? = nil
    var onClaim: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)

                if completed {
                    Image(systemName: "flag.checkered")
                        .font(.caption2)
                        .foregroundStyle(.green)
                }

                Spacer()

                Text("\(progress)/\(total)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            ProgressView(
                value: Double(progress),
                total: Double(max(total, 1))
            )
            .tint(completed ? .green : .orange)

            if completed {
                if let onClaim {
                    Button {
                        onClaim()
                    } label: {
                        Label(
                            reward.map { "Claim +🪙\($0)" } ?? "Claim Reward",
                            systemImage: "gift.fill"
                        )
                        .font(.caption.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                } else {
                    Text("Claim your reward in the Goals tab")
                        .font(.caption2)
                        .foregroundStyle(.green)
                }
            }
        }
    }
}
