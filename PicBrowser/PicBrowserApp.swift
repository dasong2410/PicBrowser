//
//  PicBrowserApp.swift
//  PicBrowser
//
//  Created by Marcus Mao on 2/28/22.
//

import SwiftUI

@main
struct PicBrowserApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
