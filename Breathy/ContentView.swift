import SwiftUI
import AVFoundation
import UIKit

struct ContentView: View {
    @EnvironmentObject var settings: BreathingSettings
    @EnvironmentObject var history: SessionHistory

    @State private var running = false
    @State private var inhalePhase = true
    @State private var timeLeft = 0
    @State private var showSettings = false
    @State private var showHistory = false

    @State private var player: AVAudioPlayer?
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 200, height: 200)
                        .scaleEffect(running ? (inhalePhase ? 1.2 : 0.6) : 0.8)
                        .animation(.easeInOut(duration: Double(currentPattern().inhale)), value: inhalePhase)
                        .onChange(of: inhalePhase) { _ in triggerHaptic() }
                    Spacer()
                    Button(running ? "Stop" : "Commencer") {
                        running ? stopSession() : startSession()
                    }
                    .font(.title2)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showSettings = true } label: { Image(systemName: "gearshape") }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showHistory = true } label: { Image(systemName: "clock") }
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView(settings: settings) }
            .sheet(isPresented: $showHistory) { HistoryView(history: history) }
        }
    }

    private func currentPattern() -> BreathingPattern {
        settings.currentPattern
    }

    private func startSession() {
        running = true
        inhalePhase = true
        timeLeft = settings.durationMinutes * 60
        history.recordSession(minutes: settings.durationMinutes)
        playSound()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            stepSession()
        }
    }

    private func stopSession() {
        running = false
        timer?.invalidate()
        timer = nil
        player?.stop()
        player = nil
    }

    private func stepSession() {
        guard running else { return }
        timeLeft -= 1
        let pattern = currentPattern()
        if timeLeft <= 0 {
            stopSession()
            return
        }
        if inhalePhase {
            if timeLeft % (pattern.inhale + pattern.exhale) == pattern.exhale {
                inhalePhase.toggle()
            }
        } else {
            if timeLeft % (pattern.inhale + pattern.exhale) == 0 {
                inhalePhase.toggle()
            }
        }
    }

    private func triggerHaptic() {
        guard settings.hapticEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }

    private func playSound() {
        guard settings.soundEnabled else { return }
        // Placeholder: expects a file named "ambient.mp3" in the bundle
        if let url = Bundle.main.url(forResource: "ambient", withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BreathingSettings())
        .environmentObject(SessionHistory())
}
