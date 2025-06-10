import SwiftUI

struct BreathingPattern: Identifiable, Codable {
    let id: String
    let name: String
    let inhale: Int
    let hold: Int
    let exhale: Int
}

final class BreathingSettings: ObservableObject {
    @AppStorage("patternIndex") var patternIndex: Int = 0
    @AppStorage("durationMinutes") var durationMinutes: Int = 3
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("hapticEnabled") var hapticEnabled: Bool = true

    static let patterns: [BreathingPattern] = [
        .init(id: "coherence", name: "Cohérence 5-5-5", inhale: 5, hold: 0, exhale: 5),
        .init(id: "478", name: "Respiration 4-7-8", inhale: 4, hold: 0, exhale: 8),
        .init(id: "fast", name: "Rapide 3-3", inhale: 3, hold: 0, exhale: 3)
    ]

    var currentPattern: BreathingPattern {
        Self.patterns[min(patternIndex, Self.patterns.count - 1)]
    }
}
