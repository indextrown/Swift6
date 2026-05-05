//
//  HomeViewModel.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import Foundation
import Alamofire
import Combine

final class HomeViewModel: ObservableObject {
    var subscription = Set<AnyCancellable>()
    @Published var catList: [Cat] = []
    private var currentPage: Int = 1
    
    init() {
        self.fetchCats(page: currentPage)
    }
}

// MARK: - logic
extension HomeViewModel {
    /// 고양이 리스트 가져오기
    /// - Parameter page: page가 1이면 기존 데이터 초기화 그렇지 않으면 기존 리스트에 추가
    func fetchCats(page: Int) {
        CatApiService.fetchCats(page: page)
            .sink { completion in
                print("HomeViewModel fetchCats completion: \(completion)")
            } receiveValue: { fetchedCats in
                if page == 1 {
                    self.catList = fetchedCats
                } else {
                    self.catList.append(contentsOf: fetchedCats)
                }
            }.store(in: &subscription)
    }
    
    /// 아래에서 위로 스크롤시 호출하는 추가 데이터 로드
    func loadMore() {
        currentPage += 1
        fetchCats(page: currentPage)
    }
    
    /// 위에서 아래로 새로고침 할 때 호출
    func refresh() {
        currentPage = 1
        fetchCats(page: currentPage)
    }
}

// MARK: - stub data
extension HomeViewModel {
    func stubFetchCats(page: Int) {
        StubCatApiService.fetchCats(page: page)
            .sink { completion in
                print("HomeViewModel fetchCats completion: \(completion)")
            } receiveValue: { fetchedCats in
                if page == 1 {
                    self.catList = fetchedCats
                } else {
                    self.catList.append(contentsOf: fetchedCats)
                }
            }.store(in: &subscription)
    }
}

