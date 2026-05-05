//
//  LoginView.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("로그인")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.bkText)
                    .padding(.top, 80)
                
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundColor(.greyDeep)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button {
                authViewModel.send(action: .googleLogin) 
            } label: {
                Text("Google로 로그인")
            }
            .buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
            
            SignInWithAppleButton { request in
                // MARK: - 인증 요청시 불리는 클로저
                authViewModel.send(action: .appleLogin(request))
            } onCompletion: { result in
                // MARK: - 인증 완료시 불리는 클로저
                authViewModel.send(action: .appleLoginCompletion(result))
            }
            .frame(height: 40)
            .padding(.horizontal, 15)
            .cornerRadius(5)
            
            
        }
        // 기존 백버튼 숨기기
        .navigationBarBackButtonHidden()
        
        // 백버튼 직접 만들기
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    // 뒤로가기
                    dismiss()
                } label: {
                    Image("back")
                }
            }
        }
        
        // MARK: - 로그인이 진행중이면 progressview보이도록
        .overlay {
            if authViewModel.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    LoginView()
}
