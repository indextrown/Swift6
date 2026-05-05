//
//  OnboardingContent.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/24/24.
//

import Foundation

// MARK: - hashable사용 이유: 탭뷰에서도 사용할거라서
struct OnboardingContent: Hashable {
    var imageFileName: String
    var title: String
    var subTitle: String
    
    // 강사: 이니셜라이저로 추후에 여러 이니셜라이저가 생길 수 있어서 생성자 선호??
    // 나: 멤버와이즈 이니셜라이절르 사용하는게 좋을거같다...
    init(imageFileName: String, title: String, subTitle: String) {
        self.imageFileName = imageFileName
        self.title = title
        self.subTitle = subTitle
    }
}
