//
//  voiceMemoApp.swift
//  voiceMemo
//

import SwiftUI

@main
struct voiceMemoApp: App {
  var body: some Scene {
    WindowGroup {
      OnboardingView()
    }
  }
}





/*
 
 App 
 - 진입점
 - Appdelegate(App에 대한 설정)
 
 Core(네트워크통신, 로컬저장..) -> 외부작용 -> 앱을 구성하면서 도움을 주는 프레임워크
 - Service(Notification)
 - Extension(기본타입들 자유롭게 커스텀)
 
 Component(디자인시스템이라고 칭함)
 - 화면구성할때 네비게이션바 or 커스텀뷰를 여기에 넣음
 
 Feature
 - 하나하나의 기능별 단위(온보딩, 홈)
 
 Model
 - 여기서는 서비스통신이 없으나 온보딩, home, todo, memo, timer에서 viewModel을 이루고 viewModel에서 사용될 stub데이터등 실제로 데이터 객체 DTO를 만드는 모델
 
 MARK: - Model을 만들고 viewModel델을 먼저 만든다(프로젝트, 사람성향차이)
 
 - View는 먼저 나오는데 통신이 안된다 -> stub을 통해 뷰모델구성하고 뷰를구성
 
 - View를 구성하면서 viewModel을 추후에 구현도 가능
 
 
 MARK: - 우리프로젝트: 모든게 주어지고 완성된 피그마로 진행되어 viewModel -> View 로 진행
 
 */
