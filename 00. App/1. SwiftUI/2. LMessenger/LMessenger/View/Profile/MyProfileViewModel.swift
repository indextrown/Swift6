//
//  MyProfileViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 2/3/25.
//

import Foundation
import SwiftUI
import PhotosUI

// 클래스 내의 모든 프로퍼티 및 메서드가 자동으로 메인 스레드에서 실행
// getUser() 메서드는 비동기 작업을 수행하므로, 기본적으로 백그라운드 스레드에서 실행될 가능성이 있음
// userInfo = user를 백그라운드 스레드에서 변경하면 UI 업데이트 관련 크래시 발생 가능성이 있음.
// @MainActor를 적용하면, 모든 프로퍼티 및 메서드가 메인 스레드에서 안전하게 실행되도록 보장됨.

@MainActor
final class MyProfileViewModel: ObservableObject {
    
    @Published var userInfo: User?
    @Published var isPresentedDescEditView: Bool = false
    
    // selection이 추가될때(didset)
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            // TODO: -
            Task {
                await updateProfileImage(pickerItem: imageSelection)
            }
        }
    }
    
    
    @Published var indexImage: UIImage?
    
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
        } catch {
            
        }
    }
    
    func updateProfileImage(pickerItem: PhotosPickerItem?) async {
        
        // 값이 없으면 리턴
        guard let pickerItem else { return }
        
        do {
            // 사진을 데이터화
            let data = try await container.services.photoPickerService.loadTransferable(from: pickerItem)
            
            // Data -> storage upload -> URL 추출
            let url = try await container.services.uploadService.uploadImage(source: .profile(userId: userId), data: data)
            
            // realtime db update(프로필 이미지 정보 업데이트)
            try await container.services.userService.updateProfileURL(userId: userId, urlString: url.absoluteString)
            
            userInfo?.profileURL = url.absoluteString
        } catch {
            print(error.localizedDescription)
        }
    }
}


