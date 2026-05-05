//
//  ChatListView.swift
//  LMessenger
//
//  Created by 김동현 on 11/1/24.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Button {
                authVM.send(action: .logout)
            } label: {
                Text("로그아웃")
                    .font(.system(size: 14))
                    .padding(.vertical, 9)
                    .padding(.horizontal, 24)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.greyLight) // 테두리만 나타남
            }
        }
    }
}

#Preview {
    ChatListView()
}
