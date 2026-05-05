//
//  MaintabView.swift
//  SwiftSkillUI
//
//  Created by 김동현 on 1/29/25.
//

// https://velog.io/@soc06212/SwiftUI-TabView-TabBar-커스터마이징
// https://sheep1sik.tistory.com/145#google_vignette
// https://toughie-ios.tistory.com/257
import SwiftUI

struct CustomMaintabView: View {
    
    @State private var selected: Tab = .a
    
    enum Tab {
        case a, b, c
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selected) {
                Group {
                    AView()
                        .tag(Tab.a)
                    BView()
                        .tag(Tab.b)
                    CView()
                        .tag(Tab.c)
                }
                .toolbar(.hidden, for: .tabBar)
            }
            VStack {
                Spacer()
                tabBar
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var tabBar: some View {
        HStack {
            Spacer()
            Button {
                selected = .a
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                    if selected == .a {
                        Text("View A")
                            .font(.system(size: 11))
                    }
                }
            }
            .foregroundStyle(selected == .a ? Color.accentColor : Color.primary)
            Spacer()
            Button {
                selected = .b
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "gauge.with.dots.needle.bottom.0percent")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                    if selected == .b {
                        Text("View B")
                            .font(.system(size: 11))
                    }
                }
            }
            .foregroundStyle(selected == .b ? Color.accentColor : Color.primary)
            Spacer()
            Button {
                selected = .c
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "fuelpump")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                    if selected == .c {
                        Text("View C")
                            .font(.system(size: 11))
                    }
                }
            }
            .foregroundStyle(selected == .c ? Color.accentColor : Color.primary)
            Spacer()
        }
        .padding()
        .frame(height: 72)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        }
        .padding(.horizontal)
    }
}

struct AView: View {
    @State private var searchText = ""
    var body: some View {
        VStack {
            TextField("검색", text: $searchText)
                .padding()
                .background(.gray)
                .cornerRadius(20)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct BView: View {
    var body: some View {
        VStack {
            Text("BView")
        }
    }
}

struct CView: View {
    var body: some View {
        VStack {
            Text("CView")
        }
    }
}

#Preview {
    CustomMaintabView()
}
