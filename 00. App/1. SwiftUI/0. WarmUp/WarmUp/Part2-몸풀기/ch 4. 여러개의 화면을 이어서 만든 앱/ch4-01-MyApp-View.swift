//
//  ch4-01-MyApp-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/8/24.
//

import SwiftUI

struct ch4_01_MyApp_View: View {
    
    @State var showModal: Bool = false
    
    var body: some View {
        TabView {
            //
            NavigationStack {
                List {
                    
                    NavigationLink {
                        Text("내용")
                    } label: {
                        Text("리스트1")
                    }
                    
                    NavigationLink {
                        Text("내용")
                    } label: {
                        Text("리스트2")
                    }
                    
                    NavigationLink {
                        Text("내용")
                    } label: {
                        Text("리스트3")
                    }

                }
            }
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
                ZStack {
                    Color.blue.ignoresSafeArea()
                    Text("온보딩1")
                }
                
                ZStack {
                    Color.green.ignoresSafeArea()
                    Text("온보딩2")
                }
                
                ZStack {
                    Color.gray.ignoresSafeArea()
                    VStack {
                        Text("온보딩3")
                        
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
    ch4_01_MyApp_View()
}
