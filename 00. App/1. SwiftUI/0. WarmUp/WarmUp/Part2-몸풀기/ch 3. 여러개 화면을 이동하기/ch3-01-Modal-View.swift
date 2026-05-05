//
//  ch3-01-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//
// MARK: - 여려 화면을 이동하기

/*
 화면을 이동하는 것
 - View가 하나의 화면
 - 여러개의 화면을 이동하는 방법
 - 우리의 일상 경험에서 떠올려 보자
 - 로그인 / 댓글은?
 - 하위 페이지에 정보가 있다면?
 - 네비게이션
 

 여러 종류의 화면을 이동해야 한다면?
 - 탭뷰를 이용해아한다
 - 온보딩의 화면 이동
 
 */

import SwiftUI

struct ch3_01_Modal_View: View {
    
    @State var showModal: Bool = false
    
    var body: some View {
        VStack {
            Text("메인 페이지 입니다")
            Button {
                // showModal = true
                showModal.toggle()
            } label: {
                Text("Modal 화면 전환")
            }
        }
        // MARK: - 이게 사라질떄 다시 showModal = false가 된다???
        .sheet(isPresented: $showModal) {
                                    // 바인딩변수   // $State변숰
            ch3_02_ModalDetail_View(isPresented: $showModal)
        }
    }
}

#Preview {
    ch3_01_Modal_View()
}

