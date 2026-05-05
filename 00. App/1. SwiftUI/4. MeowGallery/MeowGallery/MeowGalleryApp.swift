//
//  MeowGalleryApp.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

/* Reference:
 https://www.youtube.com/watch?v=NKp3q1JTZu8
 https://semin1127.tistory.com/entry/SwiftUI-TabView란-사용-예시-배경색-및-아이템-색-변경-등
 https://dadahae0320.tistory.com/41
 */

import SwiftUI

@main
struct MeowGalleryApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
