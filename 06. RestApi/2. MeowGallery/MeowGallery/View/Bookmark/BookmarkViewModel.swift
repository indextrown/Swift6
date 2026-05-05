//
//  BookmarkViewModel.swift
//  MeowGallery
//
//  Created by 김동현 on 3/23/25.
//

import SwiftUI
import Alamofire
import Combine

final class BookmarkViewModel: ObservableObject {
    var subscription = Set<AnyCancellable>()
    @Published var bookmarkedCatList: [AppCat] = []
    
    init () {
        fetchBookmarkedCats()
    }
}

// MARK: - logic
extension BookmarkViewModel {
    // MARK: - Read
    // 북마크 고양이 목록을 불러오는 함수
    func fetchBookmarkedCats() {
        CatApiService.fetchBookmarkedCats()
            .sink { completion in
                print("BookmarkViewModel fetchBookmarkedCats completion: \(completion)")
            } receiveValue: { fetchedCats in
                let convertedCats = fetchedCats.map { $0.toAppCat() }
                self.bookmarkedCatList = convertedCats
            }.store(in: &subscription)
    }
    
    // MARK: - Update
    // 고양이 북마크 추가
    func bookmarkCat(id: String) {
        CatApiService.bookmarkCat(id: id)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error adding bookmarked cat: \(error)")
                }
            } receiveValue: { fetchedCats in
                // 북마크 추가 후 즐겨찾기 목록을 업데이트
                 self.fetchBookmarkedCats()
            }.store(in: &subscription)
    }
    
    // MARK: - Delete
    // 고양이 북마크 해제
    func removeBookmarkCat(bookmarkId: Int) {
        CatApiService.removeBookmarkCat(bookmarkId: bookmarkId)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error adding bookmarked cat: \(error)")
                }
            } receiveValue: { fetchedCats in
                // 북마크 제거 후 즐겨찾기 목록을 업데이트
                 self.fetchBookmarkedCats()
            }.store(in: &subscription)
    }
}

// MARK: - stub data
extension BookmarkViewModel {
    func stubFetchBookmarkedCats() {
        StubCatApiService.fetchBookmarkedCats()
            .sink { completion in
                print("UserVM fetchBookmarkedCats completion: \(completion)")
            } receiveValue: { fetchedCats in
                let convertedCats = fetchedCats.map { $0.toAppCat() }
                self.bookmarkedCatList = convertedCats
            }.store(in: &subscription)
    }
}
 
