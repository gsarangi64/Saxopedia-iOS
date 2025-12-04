//
//  SettingsView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

//
//  SettingsView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsModel
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var showingTimePicker = false
    @State private var showingNotificationAlert = false
    
    var body: some View {
        Form {
            Section(String(localized: "Appearance")) {
                Toggle(String(localized: "Dark Mode"), isOn: $settings.darkMode)
                    .toggleStyle(SwitchToggleStyle(tint: Color("AccentColor")))
            }
            
            Section(String(localized: "Content")) {
                Toggle(String(localized: "Show Composer Info"), isOn: $settings.showComposerInfo)
                    .toggleStyle(SwitchToggleStyle(tint: Color("AccentColor")))
                
                Toggle(String(localized: "Auto Refresh"), isOn: $settings.autoRefresh)
                    .toggleStyle(SwitchToggleStyle(tint: Color("AccentColor")))
            }
            
            Section(String(localized: "Notifications")) {
                Toggle(String(localized: "Enable Notifications"), isOn: $settings.notificationsEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: Color("AccentColor")))
                    .onChange(of: settings.notificationsEnabled) { enabled in
                        if enabled {
                            Task {
                                do {
                                    try await notificationManager.requestAuthorization()
                                    notificationManager.scheduleDailyPracticeReminder(
                                        hour: settings.reminderHour,
                                        minute: settings.reminderMinute
                                    )
                                } catch {
                                    settings.notificationsEnabled = false
                                    showingNotificationAlert = true
                                }
                            }
                        } else {
                            notificationManager.cancelDailyPracticeReminder()
                        }
                    }
                
                if settings.notificationsEnabled {
                    HStack {
                        Text(String(localized: "Daily Reminder"))
                        Spacer()
                        Text(settings.dailyReminderTime)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingTimePicker = true
                    }
                    
                    Button(String(localized: "Send Test Notification")) {
                        notificationManager.sendTestNotification()
                    }
                    .foregroundColor(Color("AccentColor"))
                }
            }
            
            Section(String(localized: "Sort Order")) {
                Picker(String(localized: "Sort Order"), selection: $settings.sortOrder) {
                    Text(String(localized: "By Title")).tag("title")
                    Text(String(localized: "By Composer")).tag("composer")
                    Text(String(localized: "By Year")).tag("year")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(String(localized: "Data Sources")) {
                Link(String(localized: "Saxophone Repertoire JSON"),
                     destination: URL(string: "https://raw.githubusercontent.com/gsarangi64/sax-repertoire-data/main/sax_repertoire.json")!)
                Link(String(localized: "Open Opus API"),
                     destination: URL(string: "https://api.openopus.org")!)
            }
        }
        .navigationTitle(String(localized: "Settings"))
        .alert(String(localized: "Notifications Disabled"), isPresented: $showingNotificationAlert) {
            Button(String(localized: "OK"), role: .cancel) { }
        } message: {
            Text(String(localized: "Please enable notifications in Settings"))
        }
        .sheet(isPresented: $showingTimePicker) {
            TimePickerView(selectedTime: $settings.dailyReminderTime)
        }
    }
}

struct TimePickerView: View {
    @Binding var selectedTime: String
    @Environment(\.dismiss) var dismiss
    
    @State private var hour = 18
    @State private var minute = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section(String(localized: "Select Time")) {
                    Picker(String(localized: "Hour"), selection: $hour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text(String(format: "%02d", hour)).tag(hour)
                        }
                    }
                    
                    Picker(String(localized: "Minute"), selection: $minute) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "Reminder Time"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save")) {
                        selectedTime = String(format: "%02d:%02d", hour, minute)
                        dismiss()
                    }
                }
            }
            .onAppear {
                let components = selectedTime.split(separator: ":")
                if components.count == 2 {
                    hour = Int(components[0]) ?? 18
                    minute = Int(components[1]) ?? 0
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SettingsModel())
            .environmentObject(NotificationManager.shared)
    }
}
