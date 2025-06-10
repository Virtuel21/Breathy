import SwiftUI

struct WelcomeView: View {
    @ObservedObject var settings: BreathingSettings
    @ObservedObject var history: SessionHistory
    @State private var messageIndex = 0
    private let messages = [
        "Respirer, c'est revenir à soi.",
        "Chaque souffle est une nouvelle chance.",
        "Là, maintenant, tout est calme.",
        "Moins de tension, plus d'attention."
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("Bienvenue dans RespireZen")
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .transition(.opacity.combined(with: .move(edge: .top)))

                VStack(spacing: 8) {
                    Text("\(history.sessions) sessions respirées")
                    Text("\(history.minutesTotal) minutes de sérénité")
                    Text("\(history.streak) jours d'affilée")
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))

                Text(messages[messageIndex])
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .transition(.opacity)

                NavigationLink(destination: ContentView().environmentObject(settings).environmentObject(history)) {
                    Label("Commencer ma session", systemImage: "wind")
                        .font(.title3)
                        .padding()
                        .background(.thinMaterial, in: Capsule())
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
                withAnimation {
                    messageIndex = (messageIndex + 1) % messages.count
                }
            }
        }
    }
}

#Preview {
    WelcomeView(settings: BreathingSettings(), history: SessionHistory())
}
