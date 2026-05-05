//
//  TitleView.swift
//  MeowGallery
//
//  Created by 김동현 on 3/23/25.
//

import SwiftUI

// [] - 전역 타이틀 뷰
struct TitleView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
        }
        .font(.system(size: 40, weight: .bold))
        
    }
}
