import SwiftUI

final class SessionHistory: ObservableObject {
    @AppStorage("sessions") private(set) var sessions: Int = 0
    @AppStorage("minutesTotal") private(set) var minutesTotal: Int = 0
    @AppStorage("lastSession") private(set) var lastSession: Double = 0
    @AppStorage("streak") private(set) var streak: Int = 0
    
    func recordSession(minutes: Int) {
        sessions += 1
        minutesTotal += minutes
        
        let now = Date()
        let calendar = Calendar.current
        let lastDate = Date(timeIntervalSince1970: lastSession)
        
        if calendar.isDateInYesterday(lastDate) {
            streak += 1
        } else if !calendar.isDateInToday(lastDate) {
            streak = 1
        }
        
        lastSession = now.timeIntervalSince1970
    }
}