//
//  ContentView.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import SwiftUI

struct MainTabView: View {
    
    // 다크모드 상태 저장
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var bookmarkViewModel = BookmarkViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        TabView {
            HomeView(homeViewModel: homeViewModel)
                .tabItem {
                    Label("홈", systemImage: "house")
                }
            BookmarkView()
                .tabItem {
                    Label("즐겨찾기", systemImage: "book.fill")
                }
            ProfileView(profileViewModel: profileViewModel)
                .tabItem {
                    Label("프로필", systemImage: "person.fill")
                }
        }
        // HomeView와 BookmarkView 모두에서 동기화 되어야 합니다
        .environmentObject(bookmarkViewModel)
        .tint(.mainBlack)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear { // 선택되지 않은부분 Uikit으로 색상 변경
            UITabBar.appearance().unselectedItemTintColor = .mainGray
        }
    }
}

#Preview {
    MainTabView()
}
