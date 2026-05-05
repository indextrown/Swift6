//
//  TodoAppTutorialApp.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/24/25.
//

import SwiftUI
import RxSwift

@main
struct TodoAppTutorialApp: App {
    
    // 앱이 실행이되면 todosVM 메모리 생성
    @StateObject var todosVM: TodosVM = TodosVM()
    
    @State var selectedTab: Int = 1
    
    var body: some Scene {
        WindowGroup {
            
            // uikit의 탭바컨트롤러와 상응
            TabView(selection: $selectedTab) {
                TodosView()
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("SwiftUi")
                        // Label("test", systemImage: "person")
                    }
                    .tag(0)
                MainVC.instantiate().getRepresentable()
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("UIKit")
                        // Label("test", systemImage: "person")
                    }
                    .tag(1)
            }
        }
    }
}
