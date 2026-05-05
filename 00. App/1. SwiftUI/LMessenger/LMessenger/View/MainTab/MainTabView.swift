//
//  MainTabView.swift
//  LMessenger
//
//  Created by 김동현 on 6/21/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @EnvironmentObject private var container: DIContainer
    @State private var selectedTab: MainTabType = .home
    
    init() {
        // 눌리지 않았을 때 색상 설정을 위해 UITabbar에 접근
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(viewModel: HomeViewModel(container: container,
                                                          userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView()
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem { Label(tab.title,
                                 image: tab.imageName(selected: selectedTab == tab)) }
                .tag(tab)
            }
        }
        .tint(.bkText) // 탭 글자 검은색으로 변경
    }
}

#Preview {
    let container = DIContainer(services: StubServices())
    MainTabView()
        .environmentObject(container)
        .environmentObject(AuthenticationViewModel(container: container))
}

//
//private extension MainTabView {
//    static let previewContainer = DIContainer(services: StubServices())
//    static let previewAuthVM = AuthenticationViewModel(container: previewContainer)
//}
//
//#Preview {
//    MainTabView()
//        .environmentObject(MainTabView.previewContainer)
//        .environmentObject(MainTabView.previewAuthVM)
//}
