//
//  Onboarding1.swift
//  WarmUp
//
//  Created by 김동현 on 10/8/24.
//

import SwiftUI

struct OnboardingView: View {
    let onboardingTitle: String
    let backgroundColor: Color
    
    var body: some View {
        
        ZStack {
            backgroundColor.ignoresSafeArea()
            //Color.blue.ignoresSafeArea()
            Text(onboardingTitle)
        }
    }
}

#Preview {
    OnboardingView(
        onboardingTitle: "온보딩 테스트",
        backgroundColor: .gray
    )
}
