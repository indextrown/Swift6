//
//  Oauth_alamofire_tutorialApp.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import SwiftUI

@main
struct Oauth_alamofire_tutorialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserViewModel())
        }
    }
}

