//
//  RespireZenApp.swift
//  RespireZen
//
//  Created by Heux Julien on 10/06/2025.
//

import SwiftUI

@main
struct RespireZenApp: App {
    @StateObject private var settings = BreathingSettings()
    @StateObject private var history = SessionHistory()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView(settings: settings, history: history)
                .environmentObject(settings)
                .environmentObject(history)
        }
    }
}