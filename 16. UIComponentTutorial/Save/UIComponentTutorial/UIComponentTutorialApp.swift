//
//  UIComponentTutorialApp.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/31/25.
//

import SwiftUI
import ScaleKit

@main
struct UIComponentTutorialApp: App {
    
    init() {
        // 1. Set screen size once at app launch
        DynamicSize.setScreenSize(UIScreen.main.bounds)

        // 2. Or explicitly set a different base device
        DynamicSize.setScreenSize(UIScreen.main.bounds, baseDevice: .iPhone15ProMax)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
