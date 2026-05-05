//
//  MainTabView.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

import SwiftUI

struct MainTabView: View {
     
    @State private var selectedTab: MainTabType = .home
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var authViewModel: AuthenticationViewModel   // userId 보유
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(viewModel: HomeViewModel(container: container, userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView()
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem { Label(tab.title, image: tab.imageName(selected: selectedTab == tab))}
                .tag(tab)
            }
        }
        // 선택된 글자 색 변경 파란색 -> 검은색
        .tint(.bkText)
    }
    // 선택되지 않은 글자 색 변경
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
}

//#Preview {
//    let container = DIContainer(services: StubServices())
//    let authViewModel = AuthenticationViewModel(container: container)
//
//    MainTabView()
//        .environmentObject(container)
//        .environmentObject(authViewModel)
//}

struct MainTabView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    
    static var previews: some View {
        MainTabView()
            .environmentObject(self.container)
            .environmentObject(AuthenticationViewModel(container: self.container))
    }
}
