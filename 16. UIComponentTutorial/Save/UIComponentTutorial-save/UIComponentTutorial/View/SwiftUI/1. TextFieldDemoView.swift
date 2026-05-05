//
//  TextFieldDemoView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/19/25.
//

import SwiftUI

struct TextFieldDemoView: View {
    @State private var text: String = ""

    var body: some View {
        VStack {
            Text("아래에 텍스트를 입력하세요")
            TextField("입력", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        .navigationTitle("TextField 데모")
    }
}


#Preview {
    TextFieldDemoView()
}
