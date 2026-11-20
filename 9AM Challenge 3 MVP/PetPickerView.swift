//
//  PetPickerView.swift
//  9AM Challenge 3 MVP
//
//  Shared pet selection used by onboarding and Profile.
//

import SwiftUI

struct PetPickerView: View {
    @Binding var selection: String

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Pick the friend who joins your food adventures. You can change this any time in Profile.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button {
                    choose(nil)
                } label: {
                    HStack(spacing: 12) {
                        Text("✨")
                            .font(.system(size: 36))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Let my reviews choose")
                                .font(.headline)
                            Text("I'll change whenever your ratings and feedback change.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if selection.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(14)
                    .background(
                        selection.isEmpty
                            ? Color.orange.opacity(0.18)
                            : Color.white
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                selection.isEmpty ? Color.orange : Color.gray.opacity(0.15),
                                lineWidth: selection.isEmpty ? 2 : 1
                            )
                    )
                }
                .buttonStyle(.plain)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(FoodPersona.allCases) { persona in
                        Button {
                            choose(persona)
                        } label: {
                            VStack(spacing: 8) {
                                Text(persona.emoji)
                                    .font(.system(size: 42))

                                Text(persona.name)
                                    .font(.subheadline.weight(.semibold))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.8)

                                Text(persona.shortTaste)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)

                                if selection == persona.rawValue {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.orange)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 165)
                            .padding(12)
                            .background(
                                selection == persona.rawValue
                                    ? persona.accent
                                    : Color.white
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        selection == persona.rawValue
                                            ? Color.orange
                                            : Color.gray.opacity(0.15),
                                        lineWidth: selection == persona.rawValue ? 2 : 1
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
    }

    private func choose(_ persona: FoodPersona?) {
        selection = persona?.rawValue ?? ""
        FoodPersonaStore.setPreferredPersona(persona)
    }
}

#Preview {
    PetPickerView(selection: .constant(""))
}
