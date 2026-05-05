//
//  ch3-02-Modal-View.swift
//  WarmUp
//
//  Created by 김동현 on 10/7/24.
//

import SwiftUI

struct ch3_02_ModalDetail_View: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Text("모달 페이지 입니다2")
            
        Button {
            isPresented = false
        } label: {
            Text("뒤로가기")
        }
    }
}

#Preview {
    ch3_02_ModalDetail_View(isPresented: .constant(true)) // 언제나 같은값(보여주는값)
}
