import SwiftUI

struct HistoryView: View {
    @ObservedObject var history: SessionHistory
    @Environment(\.dismiss) private var dismiss

    private var lastDate: String {
        guard history.lastSession > 0 else { return "-" }
        let date = Date(timeIntervalSince1970: history.lastSession)
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
    }

    var body: some View {
        NavigationStack {
            Form {
                LabeledContent("Sessions", value: "\(history.sessions)")
                LabeledContent("Dernière séance", value: lastDate)
                LabeledContent("Streak", value: "\(history.streak) jours")
            }
            .navigationTitle("Historique")
            .toolbar { Button("OK") { dismiss() } }
        }
    }
}
