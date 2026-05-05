//
//  ch4-02-MyApp-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/8/24.
//

import SwiftUI

struct MyApp: View {
    @State var showModal: Bool = false
    
    var body: some View {
        TabView {
            //
            FirstView()
                .tabItem {
                    Label("first", systemImage: "tray.and.arrow.down.fill")
                }
            
            //
            Text("두 번째 페이지")
                .tabItem {
                    Label("first", systemImage: "tray.and.arrow.down.fill")
                }
            
            //
            Text("세 번째 페이지")
                .tabItem {
                    Label("first", systemImage: "tray.and.arrow.down.fill")
                }
            
            //
            Text("네 번째 페이지")
                .tabItem {
                    Label("first", systemImage: "tray.and.arrow.down.fill")
                }
        }
        .sheet(isPresented: $showModal, content: {
            TabView {
                // 첫화면(추상화)
                OnboardingView(onboardingTitle: "온보딩 1", backgroundColor: .gray)
                
                // 두번째 화면(추상화)
                OnboardingView(onboardingTitle: "온보딩 2", backgroundColor: .green)
            
                // 세번째 화면
                ZStack {
                    Color.gray.ignoresSafeArea()
                    VStack {
                        Text("온보딩3")
                        
                        // if문으로 감출 수 있다
                        Button {
                            showModal = false
                        } label: {
                            Text("Start")
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .tabViewStyle(.page)
        })
        .onAppear {
            // showModal = true
        }
    }
}

#Preview {
    MyApp()
}
