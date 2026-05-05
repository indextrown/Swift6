//
//  MyProfileViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 11/18/24.
//

import Foundation
import SwiftUI
import PhotosUI

// MARK: - MainActor설정하면 클래스 내의 프로퍼티와 속성들이 MainActor에서 엑세스 가능헤진다
@MainActor
class MyProfileViewModel: ObservableObject {
    
    // 유저정보
    @Published var userInfo: User?
    @Published var isPresentedDescEditView: Bool = false
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            // TODO: -
        }
    }
    
    private let userId: String
    
    private var container: DIContainer

    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId 
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
    
    func updateDescription(_ description: String) async {
        do {
            try await container.services.userService.updateDescription(userId: userId, description: description)
            userInfo?.description = description // 업데이트성공하면 작업
        } catch {
            
        }
    }
    
}



