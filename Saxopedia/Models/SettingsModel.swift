//
//  SettingsModel.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

class SettingsModel: ObservableObject {
    @Published var darkMode = false
    @Published var showComposerInfo = true
}
