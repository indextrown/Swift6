//
//  NetworkingManager.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import Foundation

// 비즈니스 모델

// Result를 위하
enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

/// 사용자가 검색어를 빠르게 입력할 때, 여러 네트워크 요청이 중첩되어 반환되면서 음악 데이터 배열(musicArrays)의 상태가 예상과 달라지는 경우에 발생합니다. 결과적으로 컬렉션뷰가 reloadData를 호출할 때, 데이터 배열의 크기가 변경되어 cellForItemAt에서 index가 범위를 벗어나게 됩니다.

final class NetworkingManager {
    
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듬
    static let shared = NetworkingManager()
    
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    // MARK: - Result타입은 성공. 실패 케이스를 담을 수 있다.
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void
    // typealias NetworkCompletion = ([Music]?) -> Void // 이렇게 해도 되는데 이러면 에러시 nil을 리턴해서 어떤 에러인지를 확인하기 어려움
    
    // https://itunes.apple.com/search?media=music&term=jezz
    
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        // print(urlString)
        
        // controller에서 fetchMusic 실행시킬때 switch로 에러처리하자
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    private let session = URLSession(configuration: .default)
    
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        
        guard let url = URL(string: urlString) else { return }
        
        //let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서 결과를 받는다
            if let musics = self.paresJSON(safeData) {
                // print("Parse 실행")
                completion(.success(musics))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아온 데이터를 분석하는 함수(동기적 실행)
    private func paresJSON(_ musicData: Data) -> [Music]? {
        do {
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

