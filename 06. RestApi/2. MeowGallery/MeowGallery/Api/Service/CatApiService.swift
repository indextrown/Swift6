//
//  CatApiService.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import SwiftUI
import Alamofire
import Combine

// 업로드 응답을 위한 모델 (옵션)
struct UploadResponse: Codable {
    let id: String
    let url: String
}

protocol CatApiServiceProtocol {
    static func fetchCats(page: Int) -> AnyPublisher<[Cat], AFError>
    static func fetchBookmarkedCats() -> AnyPublisher<[Cat], AFError>
    static func bookmarkCat(id: String) -> AnyPublisher<Void, AFError>
    static func removeBookmarkCat(bookmarkId: Int) -> AnyPublisher<Void, AFError>
    static func fetchMyCats() -> AnyPublisher<[Cat], AFError>
    static func uploadCat(image: UIImage) -> AnyPublisher<Void, AFError>
}

/// 싱글톤 - 단일 인스턴스를 전체에서 공유할 수 있는 디자인패턴
/// 한개만 생성해서 전역에 두고 해당 Instance에만 접근 의도
final class CatApiService: CatApiServiceProtocol {
    static let shared = CatApiService()
    private init() {}
    static let API_KEY = Bundle.main.infoDictionary?["API_KEY"] as! String
    
    static func fetchCats(page: Int) -> AnyPublisher<[Cat], AFError> {
        ApiClient.shared.session
            .request(CatRouter.fetchCats(format: "json", limit: 20, page: page))
            .publishDecodable(type: [Cat].self)
            .value()
            .map { $0 }.eraseToAnyPublisher()
    }
    
    static func fetchBookmarkedCats() -> AnyPublisher<[Cat], AFError> {
        ApiClient.shared.session
            .request(CatRouter.fetchBookmarkedCats)
            .publishDecodable(type: [BookmarkedCat].self)
            .value()
            .map { $0.map { $0.toCat() } }.eraseToAnyPublisher()
    }
    
    static func bookmarkCat(id: String) -> AnyPublisher<Void, AFError> {
        ApiClient.shared.session
            .request(CatRouter.bookmarkCat(id: id))
            .publishData()              // DataRequest -> DataResponsePublisher
            .value()                    // 데이터만 추출
            .map { _ in () }            // 결과를 Void로 매핑
            .eraseToAnyPublisher()      // AnyPublisher로 변환
    }
    
    static func removeBookmarkCat(bookmarkId: Int) -> AnyPublisher<Void, AFError> {
        ApiClient.shared.session
            .request(CatRouter.removeBookmarkedCat(bookmarkId: bookmarkId))
            .publishData()
            .value()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    static func fetchMyCats() -> AnyPublisher<[Cat], AFError> {
        ApiClient.shared.session
            .request(CatRouter.fetchMyCats(limit: 100))
            .publishDecodable(type: [MyCat].self)
            .value()
            .map { $0.map { $0.toCat() } }.eraseToAnyPublisher()
    }
    
    // 이미지 업로드 멀티파트부분은 인터넷 블로그를 참고하였습니다
    static func uploadCat(image: UIImage) -> AnyPublisher<Void, AFError> {
        let url = "\(ApiClient.BASE_URL)images/upload"
        
        return AF.upload(multipartFormData: { formData in
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                formData.append(imageData,
                                withName: "file",
                                fileName: "upload.jpeg",
                                mimeType: "image/jpeg")
                // formData.append(Data(subId.utf8), withName: "sub_id") // 이 부분 선택적으로
            }
        }, to: url, headers: ["x-api-key": API_KEY ]) // API 키 입력
        .validate(statusCode: 200..<300)
        .publishDecodable(type: UploadResponse.self)
        .value()
        .map { _ in }
        .eraseToAnyPublisher()
    }
    
    static func removeMyCat(id: String) -> AnyPublisher<Void, AFError> {
        ApiClient.shared.session
            .request(CatRouter.removeMyCats(id: id))
            .publishData()
            .value()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

// stubData
final class StubCatApiService: CatApiServiceProtocol {
    static let shared = StubCatApiService()
    private init() {}
    
    static func fetchCats(page: Int) -> AnyPublisher<[Cat], AFError> {
        Just([.stubCat1, .stubCat2, .stubCat3])
            .setFailureType(to: AFError.self)
            .eraseToAnyPublisher()
    }
    
    static func fetchBookmarkedCats() -> AnyPublisher<[Cat], AFError> {
        Just([.stubCat1, .stubCat2, .stubCat3])
            .setFailureType(to: AFError.self)
            .eraseToAnyPublisher()
    }
    
    static func bookmarkCat(id: String) -> AnyPublisher<Void, Alamofire.AFError> {
        return Empty().eraseToAnyPublisher()
    }
    
    static func removeBookmarkCat(bookmarkId: Int) -> AnyPublisher<Void, AFError> {
        return Empty().eraseToAnyPublisher()
    }
    
    static func fetchMyCats() -> AnyPublisher<[Cat], AFError> {
        Just([.stubCat1, .stubCat2, .stubCat3])
            .setFailureType(to: AFError.self)
            .eraseToAnyPublisher()
    }
    
    static func uploadCat(image: UIImage) -> AnyPublisher<Void, AFError> {
        return Empty().eraseToAnyPublisher()
    }
}

