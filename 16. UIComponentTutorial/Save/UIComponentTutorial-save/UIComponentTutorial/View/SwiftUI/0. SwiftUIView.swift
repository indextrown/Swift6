//
//  SwiftUIView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/18/25.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("UITextfield") {
                    NavigationLink("기본 텍스트필드 예제") {
                        TextFieldDemoView()
                    }
                }
            }
//            .scrollContentBackground(.hidden) // ✅ iOS 16+
//            .background(Color(.systemBackground)) // ✅ 배경 명시
        }
    }
}

#Preview {
    SwiftUIView()
}
