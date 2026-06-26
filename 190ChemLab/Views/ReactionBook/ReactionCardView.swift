import SwiftUI

struct ReactionCardView: View {
    let reaction: Reaction
    let isLocked: Bool
    let element1: Element?
    let element2: Element?
    let resultElement: Element?
    let onTap: (() -> Void)?

    var body: some View {
        Button {
            onTap?()
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    reactionFormula
                    Spacer()
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(AppColors.textSecondary)
                            .padding(8)
                            .background(Circle().fill(AppColors.cardBackground))
                    } else {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(AppColors.accent)
                    }
                }

                Text(isLocked ? "Discover this reaction in the laboratory" : reaction.description)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)

                HStack {
                    BadgeView(
                        text: reaction.difficulty.rawValue,
                        color: Color(hex: reaction.difficulty.colorHex)
                    )
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                        Text("+\(reaction.difficulty.points)")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(
                                isLocked
                                ? AppColors.textSecondary.opacity(0.15)
                                : AppColors.accent.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
            .opacity(isLocked ? 0.7 : 1)
        }
        .buttonStyle(.plain)
        .disabled(onTap == nil)
    }

    private var reactionFormula: some View {
        HStack(spacing: 8) {
            formulaOrb(element1, locked: isLocked)
            Text("+").font(.caption).foregroundColor(AppColors.textSecondary)
            formulaOrb(element2, locked: isLocked)
            Image(systemName: "arrow.right")
                .font(.caption2)
                .foregroundColor(AppColors.accent)
            formulaOrb(isLocked ? nil : resultElement, locked: isLocked, isResult: true)
        }
    }

    private func formulaOrb(_ element: Element?, locked: Bool, isResult: Bool = false) -> some View {
        VStack(spacing: 2) {
            if let element {
                Text(element.emoji).font(.title3)
                Text(element.symbol)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(isResult ? AppColors.accent : AppColors.textSecondary)
            } else {
                Text(locked ? "❓" : "?").font(.title3)
                Text("???")
                    .font(.system(size: 9))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(width: 44)
    }
}

struct ReactionDetailSheet: View {
    let reaction: Reaction
    let element1: Element?
    let element2: Element?
    let resultElement: Element?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        Text(reaction.isDiscovered ? "⚗️" : "🔒")
                            .font(.system(size: 52))

                        Text(reaction.isDiscovered ? "Discovered Reaction" : "Locked Reaction")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(reaction.isDiscovered ? AppColors.accent : AppColors.textSecondary)

                        GlassCard(accent: Color(hex: reaction.difficulty.colorHex)) {
                            VStack(spacing: 16) {
                                HStack(spacing: 16) {
                                    if let element1 { ElementOrbView(element: element1, size: 56) }
                                    Text("+").foregroundColor(AppColors.textSecondary)
                                    if let element2 { ElementOrbView(element: element2, size: 56) }
                                    Image(systemName: "arrow.right").foregroundColor(AppColors.accent)
                                    if let resultElement {
                                        ElementOrbView(element: resultElement, size: 56)
                                    } else {
                                        Text("❓").font(.largeTitle)
                                    }
                                }

                                Text(reaction.description)
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.textPrimary)
                                    .multilineTextAlignment(.center)

                                HStack {
                                    BadgeView(text: reaction.difficulty.rawValue, color: Color(hex: reaction.difficulty.colorHex))
                                    BadgeView(text: "+\(reaction.difficulty.points) points", color: AppColors.accent)
                                }
                            }
                            .padding(20)
                        }
                    }
                    .padding(20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(AppColors.accent)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
