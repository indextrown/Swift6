//
//  ContentView.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 160))
                Spacer()
                
                // 로그인
                NavigationLink {
                    LoginView()
                } label: {
                    HStack {
                        Spacer()
                        Text("로그인 하러가기")
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .padding(.bottom, 10)
                
                // 회원가입
                NavigationLink {
                    RegisterView()
                } label: {
                    HStack {
                        Spacer()
                        Text("회원가입 하러가기")
                        Spacer()
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                Spacer().frame(height: 40)
                
                NavigationLink {
                    ProfileView()
                } label: {
                    HStack {
                        Spacer()
                        Text("내프로필 보러가기")
                        Spacer()
                    }
                    .padding()
                    .background(Color.purple)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .padding(.bottom, 10)
                
                NavigationLink {
                    UserListView()
                } label: {
                    HStack {
                        Spacer()
                        Text("사용자 목록 보러가기")
                        Spacer()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                Spacer()
                Spacer()
            } // VStack
            .padding()
        }// NavigationStack
    }
}

#Preview {
    ContentView()
}
