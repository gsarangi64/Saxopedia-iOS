//
//  NotificationManager.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/4/25.
//

import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    func requestAuthorization() async throws {
        let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        
        await MainActor.run {
            self.isAuthorized = granted
        }
        
        if granted {
            print("Notification authorization granted")
        } else {
            print("Notification authorization denied")
        }
    }
    
    func scheduleDailyPracticeReminder(hour: Int = 18, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["practiceReminder"])
        
        let content = UNMutableNotificationContent()
        content.title = String(localized: "practice_reminder_title")
        content.body = String(localized: "practice_reminder_body")
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "practiceReminder",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelDailyPracticeReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["practiceReminder"])
    }
    
    func checkAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        await MainActor.run {
            self.isAuthorized = settings.authorizationStatus == .authorized
        }
    }
    
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "practice_reminder_title")
        content.body = String(localized: "practice_reminder_body")
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
