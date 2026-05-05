////
////  ContentView.swift
////  MeowGallery
////
////  Created by 김동현 on 3/22/25.
////
//
//import SwiftUI
//
//
//enum MainTabType: CaseIterable {
//    case homeView
//    case bookmarkView
//    case profileView
//}
//
//extension MainTabType {
//    var title: String {
//        switch self {
//        case .homeView:
//            return "홈"
//        case .bookmarkView:
//            return "즐겨찾기"
//        case .profileView:
//            return "프로필"
//        }
//    }
//    
//    var imageName: String {
//        switch self {
//        case .homeView:
//            return "house"
//        case .bookmarkView:
//            return "book.fill"
//        case .profileView:
//            return "person.fill"
//        }
//    }
//}
//
//struct MainTabView: View {
//    
//    // 다크모드 상태 저장
//    @AppStorage("isDarkMode") private var isDarkMode = false
//    @StateObject var homeViewModel = HomeViewModel()
//    @StateObject var bookmarkViewModel = BookmarkViewModel()
//    @StateObject var profileViewModel = ProfileViewModel()
//    
//    // MARK: [피드백]: 탭을 프로그램적으로 선택할 수 있어야한다
//    @State private var selectedTab = MainTabType.homeView
//    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            HomeView(homeViewModel: homeViewModel)
//                .tabItem {
//                    Label(tab.title, systemImage: tab.imageName)
//                }
//                .tag(tab)
//            BookmarkView()
//                .tabItem {
//                 
//                }
//            ProfileView()
//                .tabItem {
//                 
//                }
//        }
//        // HomeView와 BookmarkView 모두에서 동기화 되어야 합니다
//        .environmentObject(bookmarkViewModel)
//        .tint(.mainBlack)
//        .preferredColorScheme(isDarkMode ? .dark : .light)
//        .onAppear { // 선택되지 않은부분 Uikit으로 색상 변경
//            UITabBar.appearance().unselectedItemTintColor = .mainGray
//        }
//    }
//}
//
//#Preview {
//    MainTabView()
//}
//
//
//


//
//  ContentView.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import SwiftUI


enum MainTabType: CaseIterable {
    case homeView
    case bookmarkView
    case profileView
    
    var title: String {
        switch self {
        case .homeView:
            return "홈"
        case .bookmarkView:
            return "즐겨찾기"
        case .profileView:
            return "프로필"
        }
    }
    
    var imageName: String {
        switch self {
        case .homeView:
            return "house"
        case .bookmarkView:
            return "book.fill"
        case .profileView:
            return "person.fill"
        }
    }
}

// [] - 탭 뷰
struct MainTabView: View {
    
    // 다크모드 상태 저장
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var bookmarkViewModel = BookmarkViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    
    // MARK: [피드백]: 탭을 프로그램적으로 선택할 수 있어야한다
    @State private var selectedTab = MainTabType.homeView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .homeView:
                        HomeView(homeViewModel: homeViewModel)
                    case .bookmarkView:
                        BookmarkView()
                    case .profileView:
                        ProfileView(profileViewModel: profileViewModel)
                    }
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.imageName)
                }
                .tag(tab)
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



