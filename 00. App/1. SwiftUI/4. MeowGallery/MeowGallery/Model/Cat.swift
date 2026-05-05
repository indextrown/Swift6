//
//  Cat.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import Foundation

// MARK: - 단순 고양이 목록 불러오기
/// Cat 구조체는 일반 고양이 정보를 표현합니다
/// 북마크(즐겨찾기) API와 동일한 구조체를 사용하기 위해, 북마크된 경우에만 채워지는 bookmarkId 프로퍼티를 옵셔널로 추가하였습니다
struct Cat: Identifiable, Codable, Hashable {
    var id: String          // 일반 고양이의 고유 식별자
    var url: String
    var bookmarkId: Int?    // 북마크 API 호출시 북마크 항목의 고유 식별자
    var createdAt: String?  // 내가 올린 사진 호출시 저장되는 날짜
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case bookmarkId
        case createdAt = "created_at"
    }
}

// MARK: - 북마크된 고양이 응답 모델
/// BookmarkedCat은 북마크된 고양이에 대한 API 응답 구조를 그대로 반영합니다.
/// 여기서 'id'는 북마크 고유번호(정수)로 전달되며, 실제 고양이 정보는 'image' 객체 내에 포함되어 있습니다.
struct BookmarkedCat: Codable {
    var bookmarkId: Int
    var userId: String
    var imageId: String
    var createdAt: String
    var image: CatImage
    
    private enum CodingKeys: String, CodingKey {
        case bookmarkId = "id"
        case userId = "user_id"
        case imageId = "image_id"
        case createdAt = "created_at"
        case image
    }
    
    struct CatImage: Codable {
        var id: String
        var url: String
    }
    
    func toCat() -> Cat {
        return Cat(
            id: imageId,
            url: image.url,
            bookmarkId: bookmarkId,
            createdAt: createdAt
        )
    }
}

// MARK: - 업로드된 고양이 응답 모델
struct MyCat: Codable {
    var id: String
    var url: String
    var created_at: String
    
    private enum codingKeys: String, CodingKey {
        case id
        case url
        case created_at
    }
    
    func toCat() -> Cat {
        return Cat(
            id: id,
            url: url,
            createdAt: created_at
        )
    }
}

// stub data
extension Cat {
    static var stubCat1: Cat {
        .init(id: "stubId_1", url: "https://d2zp5xs5cp8zlg.cloudfront.net/image-79322-800.jpg")
    }
    static var stubCat2: Cat {
        .init(id: "stubId_2", url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQY_UE1Bx5UQ_OWiAmrE6zsk4_YXsUfz5SnFw&s")
    }
    static var stubCat3: Cat {
        .init(id: "stubId_3", url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqN7AzVBbssaIcFBbcuZvSwybxwgVZKP0Zdw&s")
    }
}

