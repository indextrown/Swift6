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
    @Published var myCatList: [Cat] = []
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
                self.myCatList = fetchedCats
                // heatmap용 디버깅 테스트
                let dateCounts = Dictionary(grouping: self.myCatList) { cat -> String in
                    return self.formattedDate(date: cat.createdAt)
                }

                for (date, cats) in dateCounts.sorted(by: { $0.key < $1.key }) {
                    print("\(date): \(cats.count)")
                }
            }.store(in: &subscription)
        /*
        StubCatApiService.fetchBookmarkedCats()
            .sink { completion in
                print("UserVM fetchBookmarkedCats completion: \(completion)")
            } receiveValue: { fetchedCats in
                self.bookmarkedCatList = fetchedCats
            }.store(in: &subscription)
         */
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
    
    func formattedDate(date: String?) -> String {
        guard let isoDate = date else { return "N/A" }
        let isoFormatter = ISO8601DateFormatter()
        // 소수점 이하 초를 파싱하기 위한 옵션 추가
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let parsedDate = isoFormatter.date(from: isoDate) else { return isoDate }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: parsedDate)
    }
}

// MARK: - stub data
extension ProfileViewModel {
    func StubFetchMyCats() {
        StubCatApiService.fetchMyCats()
            .sink { completion in
                print("UserVM fetchBookmarkedCats completion: \(completion)")
            } receiveValue: { fetchedCats in
                self.myCatList = fetchedCats
            }.store(in: &subscription)
         
    }
}

// test
extension ProfileViewModel {
    // 새로운 오버로드: Date를 입력받음
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    // 히트맵 데이터 생성
    func getHeatmapData() -> [HeatmapData] {
        let calendar = Calendar.current
        let today = Date()
        
        // 112일치의 데이터 생성 (16주 x 7일)
        let dates = (0..<112).map { days -> Date in
            calendar.date(byAdding: .day, value: -days, to: today)!
        }.reversed()
        
        // 날짜별 고양이 업로드 횟수 계산
        let dateCounts = Dictionary(grouping: myCatList) { cat -> String in
            return formattedDate(date: cat.createdAt)
        }
        
        // HeatmapData 배열 생성
        return dates.map { date in
            let dateString = formattedDate(date: date)
            let count = dateCounts[dateString]?.count ?? 0
            return HeatmapData(date: date, count: count)
        }
    }
}
