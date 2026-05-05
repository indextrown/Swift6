//
//  LoginView.swift
//  LMessenger
//
//  Created by 김동현 on 10/30/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    // 상위뷰에서 AuthenticationViewModel 객체를 environmentObject로 주입해줘서 사용가능
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.bkText)
                    .padding(.top, 80)
                    
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundColor(.greyDeep)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button {
                // TODO: - Google login
                authViewModel.send(action: .googleLogin)
            } label: {
                Text("Google로 로그인")
            }.buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
            

            SignInWithAppleButton { result in
                // TODO: -
                authViewModel.send(action: .appleLogin(result))
            } onCompletion: { result in
                // TODO: - result 성공시 firebase인증 진행
                authViewModel.send(action: .appleLoginCompletion(result))
            }
            .frame(maxWidth: 375)
            .frame(height: 40)
            .padding(.horizontal, 15)
            .cornerRadius(5)

        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    // TODO: - back
                    dismiss()
                } label: {
                    Image("back")
                }
            }
        }
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

