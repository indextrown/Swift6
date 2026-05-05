//
//  NetworkManagerStudy.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import Foundation

final class NetworkingManagerStudy {
    
    // MARK: - 일반적으로 네트워크매니저는 싱글톤으로 만듬
    // 자기자신을 생성하여 타입 저장속성에 할당
    // 이 shared 변수는 data 영역에 존재, 싱글톤은 heap 영역에 존재 -> 이 프로젝트에서 하나만 존재
    // 이렇게 구현 이유: 생성자를 이 프러젝트에서 하나만 사용하려는 의도
    static let shared = NetworkingManagerStudy()
    
    func getMethod(completion: @escaping ([Music]?) -> Void) {
        // URL 구조체 만들기
        guard let url = URL(string: "") else {
            print("Error: URL을 만들 수 없습니다")
            completion(nil)
            return
        }
        
        // URL 요청 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GER"
        
        // 요청을 가지고 작업세션 시작
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 에러가 없을때만 계속 진행
            guard error == nil else {
                print("Error: GET 요청 실패")
                print(error!)
                completion(nil)
                return
            }
            
            // 옵셔널 바인딩
            guard let safeData = data else {
                print("Error: 데이터를 받지 못했습니다")
                completion(nil)
                return
            }
            
            // HTTP 2000번대 정상코드일 경우에만 다음 코드로 넘어감
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP 요청 실패하였습니다")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let musicData = try decoder.decode(MusicData.self, from: safeData)
                completion(musicData.results)
                return
            } catch {
                
            }
        }.resume() // 시작
        
    }
}
