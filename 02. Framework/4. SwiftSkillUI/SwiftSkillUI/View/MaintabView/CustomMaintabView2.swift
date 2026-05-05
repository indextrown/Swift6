//
//  CustomMaintabView2.swift
//  SwiftSkillUI
//
//  Created by 김동현 on 1/29/25.
//
import SwiftUI

enum MainTabType: CaseIterable {
    case csView
    case iosView
    case aosView
    case profileView
    
    var title: String {
        switch self {
        case .csView:
            return "CS"
        case .iosView:
            return "iOS"
        case .aosView:
            return "aOS"
        case .profileView:
            return "profile"
        }
    }
    
    func imageName(isSelected: Bool) -> String {
        switch self {
        case .csView:
            return isSelected ? "desktopcomputer" : "desktopcomputer"
        case .iosView:
            return isSelected ? "apple.logo" : "apple.logo"
        case .aosView:
            return isSelected ? "smartphone" : "smartphone"
        case .profileView:
            return isSelected ? "person.fill" : "person"
        }
    }
}

struct CustomMaintabView2: View {
    
    @State private var selectedTab: MainTabType = .csView
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack(spacing: 0) {
                switch selectedTab {
                case .csView:
                    CSView()
                case .iosView:
                    iOSView()
                case .aosView:
                    AosView()
                case .profileView:
                    ProfileView()
                }
            }

            VStack(spacing: 0) {
                Spacer()
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                HStack {
                    ForEach(MainTabType.allCases, id: \.self) { tab in
                        
                        Spacer()
                            .frame(width: 10)
                        
                        VStack {
                            Spacer()
                                .frame(height: 5)
                            Image(systemName: tab.imageName(isSelected: selectedTab == tab))
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                            Text(tab.title)
                                .font(.caption2)
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                            Spacer()
                                .frame(height: 20)
                        }
                        .padding(.horizontal, 20) // 좌우 터치 영역 추가
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle()) // 터치 가능한 영역을 명시적으로 지정
                        .onTapGesture {
                            // 진동 발생
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            selectedTab = tab
                        }
                        Spacer()
                            .frame(width: 10)
                    }
                    .frame(height: 100) // 고정 높이
                }
                .background(.black)
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    CustomMaintabView2()
}

struct CSView: View {
    @State private var searchText = ""
    var body: some View {
        ZStack {
            Color.mainBlack
            
            VStack {
                TextField("검색", text: $searchText)
                    .padding()
                    .background(.gray)
                    .cornerRadius(20)
            }
        }
        .ignoresSafeArea()
    }
}

struct iOSView: View {
    var body: some View {
        VStack {
            Text("iOSView")
                .foregroundStyle(.white)
        }
    }
}

struct AosView: View {
    var body: some View {
        VStack {
            Text("AOSView")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("ProfileView")
        }
    }
}
