//
//  LoginView.swift
//  LMessenger
//
//  Created by 김동현 on 6/21/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            /// Group은 여러개의 View 들에 동일한 속성을 부여하고 싶을때 사용한다
            Group {
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.bkText)
                    .padding(.top, 80)
                
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.greyDeep)
            }.padding(.horizontal, 30)
            
            Spacer()
            
            Button {
                authViewModel.send(action: .googleLogin)
            } label: {
                Text("Google로 로그인")
            }.buttonStyle(LoginButtonStyle(textColor: .bkText,
                                           borderColor: .greyLight))
            
            SignInWithAppleButton { request in
                // 인증요청시 불리는 클로저, request로 원하는 정보, nonce 세팅
                // TODO: -
                authViewModel.send(action: .appleLogin(request))
            } onCompletion: { result in
                // 인증 완료시 불리는 클로저 성공시 firebase인증 진행
                // TODO: -
                authViewModel.send(action: .appleLoginCompletion(result))
            }
            .frame(height: 40)
            .padding(.horizontal, 30)

        }
        .navigationBarBackButtonHidden() /// 기존 뒤로가기버튼 비활성화
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
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
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: StubServices())))
}
