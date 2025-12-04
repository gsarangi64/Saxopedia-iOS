//
//  SettingsModel.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation
import SwiftUI

class SettingsModel: ObservableObject {
    @AppStorage("darkMode") var darkMode = false
    @AppStorage("showComposerInfo") var showComposerInfo = true
    @AppStorage("notificationsEnabled") var notificationsEnabled = false
    @AppStorage("dailyReminderTime") var dailyReminderTime = "18:00"
    @AppStorage("sortOrder") var sortOrder = "title"
    @AppStorage("autoRefresh") var autoRefresh = true
    
    let sortOptions = ["title", "composer", "year"]
    
    var reminderHour: Int {
        let components = dailyReminderTime.split(separator: ":")
        return Int(components.first ?? "18") ?? 18
    }
    
    var reminderMinute: Int {
        let components = dailyReminderTime.split(separator: ":")
        return Int(components.last ?? "0") ?? 0
    }
}
