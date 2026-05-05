//
//  0. SwiftUIView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/31/25.
//

import SwiftUI

struct SwiftUIListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("텍스트필드") {
                    NavigationLink("기본 텍스트필드 예제") {
                        SlideView()
                    }
                }
                
                Section("Mapkit") {
                    NavigationLink("MapKit") {
                        Mapkit()
                    }
                }
                
                Section("LiquidGlass") {
                    NavigationLink("LiquidGlass") {
                        LiquidGlass()
                    }
                    NavigationLink("MapkitLiquidGlass") {
                        MapkitLiquidGlass()
                    }
                }
                
                Section("UI") {
                    NavigationLink("LoginView") {
                        LoginView()
                    }
                }
                
                
                
                
                
            }
            // .navigationTitle("메뉴")
            // .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SwiftUIListView()
}
