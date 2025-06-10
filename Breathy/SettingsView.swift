import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: BreathingSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Rythme")) {
                    Picker("Rythme", selection: $settings.patternIndex) {
                        ForEach(Array(BreathingSettings.patterns.enumerated()), id: \.offset) { index, pattern in
                            Text(pattern.name).tag(index)
                        }
                    }
                }
                
                Section(header: Text("Durée")) {
                    Picker("Durée", selection: $settings.durationMinutes) {
                        ForEach([1,3,5,10], id: \.self) { minute in
                            Text("\(minute) min").tag(minute)
                        }
                    }
                }
                
                Section(header: Text("Options")) {
                    Toggle("Sons", isOn: $settings.soundEnabled)
                    Toggle("Vibrations", isOn: $settings.hapticEnabled)
                }
            }
            .navigationTitle("Paramètres")
            .toolbar { Button("OK") { dismiss() } }
        }
    }
}