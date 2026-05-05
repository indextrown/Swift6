//
//  RegisterView.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

/*
 회원가입뷰 ->
 회원가입버튼 ->
 userViewModel.register ->
 AuthApiService.register ->
 userViewModel에서 sink로 구독하여 받아서 차리 ->
 userViewModel.registrationSuccess.send() ->
 회원가입뷰 onReceive -> 
 */

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel // 외부에서 userViewModel을 생성했기 때문에 환경변수로서 접근 가능하다
    @Environment(\.dismiss) var dismiss
    @State var nameInput: String = ""
    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    @State fileprivate var shouldShowAlert: Bool = false
    
    var body: some View {
        VStack {
            Form {
                // 이름
                Section(header: Text("이름")) {
                    TextField("이름", text: $nameInput).keyboardType(.default)
                }
                // 이메일
                Section(header: Text("이메일")) {
                    TextField("이메일", text: $emailInput).keyboardType(.emailAddress).autocapitalization(.none)
                }
                // 비밀번호
                Section(header: Text("로그인 정보")) {
                    SecureField("비밀번호", text: $passwordInput).keyboardType(.emailAddress).autocapitalization(.none)
                    SecureField("비밀번호 확인", text: $passwordInput).keyboardType(.emailAddress).autocapitalization(.none)
                }
                
                Section {
                    Button {
                        print("회원가입 버튼 클릭")
                        userViewModel.register(name: nameInput, email: emailInput, password: passwordInput)
                    } label: {
                        Text("회원가입 하기")
                    }
                }
            }
            .onReceive(userViewModel.registrationSuccess) {
                print("RegisterView - registrationSuccess() called")
                self.shouldShowAlert = true
            }
            .alert("회원가입이 완료되었습니다.", isPresented: $shouldShowAlert) {
                Button("확인", role: .cancel) {
                    self.dismiss()
                }
            }
        }.navigationTitle("회원가입 하기")
    }
}

#Preview {
    RegisterView()
}

