//
//  LoginView.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State fileprivate var shouldShowAlert: Bool = false
    @State var emailInput: String = "index@email.com"
    @State var passwordInput: String = "1q2w3e4r!"
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("로그인 정보")) {
                    TextField("이메일", text: $emailInput).keyboardType(.emailAddress).autocapitalization(.none)
                    SecureField("비밀번호", text: $passwordInput).keyboardType(.default)
                }
                
                Section {
                    Button {
                        print("로그인 버튼 클릭")
                        userViewModel.login(email: emailInput, password: passwordInput)
                    } label: {
                        Text("로그인 하기")
                    }
                }
            }
            .onReceive(userViewModel.loginSuccess) {
                print("RegisterView - loginSuccess() called")
                self.shouldShowAlert = true
            }
            .alert("로그인이 완료되었습니다.", isPresented: $shouldShowAlert) {
                Button("확인", role: .cancel) {
                    self.dismiss()
                }
            }
        }.navigationTitle("로그인 하기")
    }
}

#Preview {
    LoginView()
}
