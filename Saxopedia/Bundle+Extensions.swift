//
//  Bundle+Extensions.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/4/25.
//

import Foundation

extension Bundle {
    var appName: String {
        return infoDictionary?["CFBundleName"] as? String ?? "Saxopedia"
    }
    
    var version: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var copyright: String {
        return infoDictionary?["NSHumanReadableCopyright"] as? String ?? "Copyright © 2025 Saxopedia. All rights reserved."
    }
    
    var displayName: String {
        return infoDictionary?["CFBundleDisplayName"] as? String ?? appName
    }
}
