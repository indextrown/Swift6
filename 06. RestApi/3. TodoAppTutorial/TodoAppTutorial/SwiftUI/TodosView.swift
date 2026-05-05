//
//  ContentView.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/24/25.
//

import SwiftUI

struct TodosView: View {
    var body: some View {
        VStack(alignment: .leading) {
            getHeader()
            UISearchBarWrapper()
            Spacer()
            
            // 리스트는 TableView를 가져오는 형태이다. 스타일을 바꾸자
            List {
                TodoRow()
                TodoRow()
                TodoRow()
            }.listStyle(.plain)
        }
    }
    
    fileprivate func getHeader() -> some View {
        Group {
            topHeader
            secondHeader
        }.padding(.horizontal, 10)
    }
    
    /// top 헤더
    fileprivate var topHeader: some View {
        Group {
            Text("TodoCopletionView / page: 2")
            Text("선택된 할일: []")
            
            HStack {
                Button(action: {}, label: { Text("클로저") })
                Button(action: {}, label: { Text("Rx") })
                Button(action: {}, label: { Text("콤바인") })
                Button(action: {}, label: { Text("Async") })
            }.buttonStyle(MyDefaultButtonStyle(bgColor: .blue, textColor: .white))
            
        }
    }
    
    /// second 헤더
    fileprivate var secondHeader: some View {
        Group {
            Text("Async 변환 액션들")
            
            HStack {
                Button(action: {}, label: { Text("클로저 👉 Async") })
                Button(action: {}, label: { Text("Rx 👉 Async") })
                Button(action: {}, label: { Text("콤바인 👉 Async") })
            }.buttonStyle(MyDefaultButtonStyle(bgColor: .blue, textColor: .white))
            
            
            HStack {
                Button(action: {}, label: { Text("초기화") })
                    .buttonStyle(MyDefaultButtonStyle(bgColor: .purple, textColor: .white))
                Button(action: {}, label: { Text("선택된\n할일둘\n삭제") })
                    .buttonStyle(MyDefaultButtonStyle(bgColor: .black, textColor: .white))
                Button(action: {}, label: { Text("할 일 추가") })
                    .buttonStyle(MyDefaultButtonStyle(bgColor: .gray, textColor: .white))
            }
        }
    }
}

#Preview {
    TodosView()
}

