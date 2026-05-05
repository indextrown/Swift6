//
//  NetworkManager.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/4/25.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError>
}

public class NetworkManager: NetworkManagerProtocol {
    private let session: SessionProtocol
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    private let tokenHeader: HTTPHeaders = {
        let API_KEY = Bundle.main.infoDictionary?["API_KEY"] as! String
        let tokenHeader = HTTPHeader(name: "Authorization", value: "Bearer \(API_KEY)")
        return HTTPHeaders([tokenHeader])
    }()
    
    /// fetchData() -> User
    /// fetchData() -> Store
    /// fetchData() -> Car
    /// 타입마다 함수 정의를 만들기보다 제네릭 함수를 만들어 여러 곳에서 갈아 끼워서 사용 가능하다
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else {
            return .failure(NetworkError.urlError)
        }
        
        let result = await session.request(url, method: method, parameters: parameters, headers: tokenHeader).serializingData().response
        if let error = result.error { return .failure(NetworkError.requestFailed(error.localizedDescription))}
        
        guard let data = result.data else { return .failure(NetworkError.dataNil)}
        guard let response = result.response else { return .failure(NetworkError.invailedResponse)}
        if 200..<400 ~= response.statusCode {
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return .success(data)
            } catch {
                return .failure(NetworkError.failToDecode(error.localizedDescription))
            }
                
        } else {
            return .failure(.serverError(response.statusCode))
        }
    }
}

// MARK: - 구현단 NetworkManager(session: UserSession())
// MARK: - 테스트 NetworkManager(session: MockSession())
