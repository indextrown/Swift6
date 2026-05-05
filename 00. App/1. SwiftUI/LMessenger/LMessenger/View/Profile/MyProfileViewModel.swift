//
//  MyProfileViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 9/21/25.
//

import Foundation

final class MyProfileViewModel: ObservableObject {
    @Published var userInfo: User?
    private var container: DIContainer
    private let userId: String /// 최신 정보를 가져와서 반영하기 위함
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    
}
