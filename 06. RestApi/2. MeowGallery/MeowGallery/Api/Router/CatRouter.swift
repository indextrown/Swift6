//
//  CatRouter.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import SwiftUI
import Alamofire

enum CatRouter: URLRequestConvertible {
    
    case fetchCats(format: String, limit: Int, page: Int)
    case fetchBookmarkedCats
    case bookmarkCat(id: String)
    case removeBookmarkedCat(bookmarkId: Int)
    case fetchMyCats(limit: Int)
    case removeMyCats(id: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .fetchCats:
            return "images/search"
        case .fetchBookmarkedCats:
            return "favourites"
        case .bookmarkCat:
            return "favourites"
        case .removeBookmarkedCat:
            return "favourites"
        case .fetchMyCats:
            return "images"
        case .removeMyCats:
            return "images"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCats, .fetchBookmarkedCats, .fetchMyCats:
            return .get
        case .bookmarkCat:
            return .post
        case .removeBookmarkedCat, .removeMyCats:
            return .delete
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .fetchCats(format, limit, page):
            var params = Parameters()
            params["format"] = format
            params["limit"] = limit
            params["page"] = page
            return params
        
        case .fetchBookmarkedCats:
            return [:]
            
        case let .bookmarkCat(id):
            var params = Parameters()
            params["image_id"] = id
            return params
            
        case .removeBookmarkedCat:
            return [:]  // DELETE 요청은 보통 URL에 ID를 포함시키므로 별도의 파라미터는 필요하지 않습니다.
            
        case let .fetchMyCats(limit):
            var params = Parameters()
            params["limit"] = limit
            return params
        case .removeMyCats:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        switch self {
        case .fetchCats, .fetchBookmarkedCats, .fetchMyCats:
            // GET 방식: URL에 query로 포함
            let url = baseURL.appendingPathComponent(endPoint)
            var request = URLRequest(url: url)
            request.method = method
            return try URLEncoding.default.encode(request, with: parameters)
            
        case .bookmarkCat:
            // POST 방식: Body에 JSON으로 포함
            let url = baseURL.appendingPathComponent(endPoint)
            var request = URLRequest(url: url)
            request.method = method
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
            return request
            
        case let .removeBookmarkedCat(bookmarkId):
            // DELETE 방식: URL에 id를 추가
            let url = baseURL.appendingPathComponent("\(endPoint)/\(bookmarkId)")
            var request = URLRequest(url: url)
            request.method = method
            request.httpBody = try URLEncoding.default.encode(request, with: parameters).httpBody
            return request
        case let .removeMyCats(id):
            // DELETE 방식: URL에 id를 추가
            let url = baseURL.appendingPathComponent("\(endPoint)/\(id)")
            var request = URLRequest(url: url)
            request.method = method
            request.httpBody = try URLEncoding.default.encode(request, with: parameters).httpBody
            return request
        }
    }
}
