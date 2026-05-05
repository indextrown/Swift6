//
//  ProfileViewModel.swift
//  MeowGallery
//
//  Created by 김동현 on 3/23/25.
//

import SwiftUI
import Alamofire
import Combine

final class ProfileViewModel: ObservableObject {
    var subscription = Set<AnyCancellable>()
    @Published var myCatList: [AppCat] = []
    @Published var isUploading: Bool = false
    
    init () {
        fetchMyCats()
    }
}

// MARK: - logic
extension ProfileViewModel {
    // MARK: - Read
    // 북마크 고양이 목록을 불러오는 함수
    func fetchMyCats() {
        CatApiService.fetchMyCats()
            .sink { completion in
                print("ProfileViewModel fetchMyCats completion: \(completion)")
            } receiveValue: { fetchedCats in
                let convertedCats = fetchedCats.map { $0.toAppCat() }
                self.myCatList = convertedCats
            }.store(in: &subscription)
    }

    // 고양이 업로드
    func uploadCat(image: UIImage) {
        isUploading = true
        
        CatApiService.uploadCat(image: image)
            .sink { completion in
                self.isUploading = false
                switch completion {
                case .finished:
                    print("Successfully uploaded cat image")
                    // 업로드 후 내 고양이 목록 새로고침
                    self.fetchMyCats()
                case .failure(let error):
                    print("Failed to upload cat image: \(error)")
                }
            } receiveValue: { _ in
                // 업로드 성공 시 새로고침
                self.fetchMyCats()
            }
            .store(in: &subscription)
    }

    // 고양이 업로드 삭제
    func removeMyCat(id: String) {
        CatApiService.removeMyCat(id: id)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error adding removeMyCat cat: \(error)")
                }
            } receiveValue: { fetchedCats in
                // 북마크 제거 후 즐겨찾기 목록을 업데이트
                 self.fetchMyCats()
            }.store(in: &subscription)
    }
}

// MARK: - stub data
extension ProfileViewModel {
    func StubFetchMyCats() {
        StubCatApiService.fetchMyCats()
            .sink { completion in
                print("UserVM fetchBookmarkedCats completion: \(completion)")
            } receiveValue: { fetchedCats in
                let convertedCats = fetchedCats.map { $0.toAppCat() }
                self.myCatList = convertedCats
            }.store(in: &subscription)
         
    }
}

