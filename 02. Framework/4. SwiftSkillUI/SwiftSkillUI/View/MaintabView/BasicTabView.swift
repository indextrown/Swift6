//
//  BasicTabView.swift
//  SwiftSkillUI
//
//  Created by 김동현 on 1/29/25.
//

import SwiftUI

struct BasicTabView: View {
    var body: some View {
        TabView {
            Text("홈화면")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            
            Text("검색 화면")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
                }
            
            Text("설정 화면")
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("설정")
                }
        }
    }
}

#Preview {
    BasicTabView()
}
