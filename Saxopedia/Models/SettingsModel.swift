//
//  SettingsModel.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation
import SwiftUI

class SettingsModel: ObservableObject {
    @Published var darkMode: Bool {
        didSet {
            UserDefaults.standard.set(darkMode, forKey: "darkMode")
        }
    }
    
    @Published var showComposerInfo: Bool {
        didSet {
            UserDefaults.standard.set(showComposerInfo, forKey: "showComposerInfo")
        }
    }
    
    init() {
        self.darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        self.showComposerInfo = UserDefaults.standard.bool(forKey: "showComposerInfo")
    }
}
