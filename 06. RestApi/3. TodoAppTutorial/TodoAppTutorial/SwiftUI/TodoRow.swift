//
//  TodoRow.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/25/25.
//

import SwiftUI

struct TodoRow: View {
    @State var isSelected: Bool = false
    var body: some View {
        // Hstack에서 alignment는 세로정렬을 의미
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("id: 123 / 완료여부: 미완료")
                Text("hello world")
            }
            // 사이즈: 가능한 최대한 늘리겠다
            .frame(maxWidth: .infinity)
            
            // Vstack에서 alignment는 가로정렬을 의미
            VStack(alignment: .trailing) {
                actionButtons
                Toggle(isOn: $isSelected) {
                    EmptyView()
                }
                .frame(width: 80)
            }
        }
        // 사이즈: 가능한 최대한 늘리겠다
        .frame(maxWidth: .infinity)
    }
    
    fileprivate var actionButtons: some View {
        HStack {
            Button(action: {}, label: { Text("수정") })
                .buttonStyle(MyDefaultButtonStyle())
                .frame(width: 80)
            Button(action: {}, label: { Text("삭제") })
                .buttonStyle(MyDefaultButtonStyle(bgColor: .purple))
                .frame(width: 80)
        }
    }
}

#Preview {
    TodoRow()
}
