//
//  0. 네트워크 통신 기초.swift
//  Swift5
//
//  Created by 김동현 on 3/11/25.
//

/*
 
 MARK: - 네트워크 개발시 유용한 도구들
 
 크롬 json viewer
 https://chromewebstore.google.com/search/json%20formatter
 
 // json데이터 -> swift 코드 변환
 https://app.quicktype.io
 
 // postman
 https://www.postman.com/downloads/
 
 아이튠즈 스토어 링크
 https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1
 
 애플 음악 검색 API 주소:
 https://itunes.apple.com/search?parameterkeyvalue
 
 api sample
 https://itunes.apple.com/search?media=music&term=movie
 https://itunes.apple.com/search?media=ebook&term=jobs
 
 */

import Foundation

// 배열이 생길 때 콜백 함수로 받는 함수를 실행 시킨다
// 콜백함수는 보통 전달하는 데이터형태 -> Void로 하면됨
func getMethod(completion: @escaping ([Music]?) -> Void) {
    
    // URL구조체 만들기
    guard let url = URL(string: "https://itunes.apple.com/search?media=ebook&term=jobs") else {
        print("Error: cannot create URL")
        completion(nil) // 콜백함수 호출
        return
    }
    
    // URL요청 생성
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // var musicArray: [Music]? = []
    
    /*
     MARK: - 이 코드는 오래 걸리는 메서드라 비동기로 처리되어있다. 그래서 일을 기다리지 않는다. -> 리턴형으로 설계하면안되고 콜백형으로 설계해야한다(dataTask는 비동기)
     그래서...배열이 생기는 시점에 다른 함수를 호출하여 결과값을 전달해야 한다.
     요청을 가지고 작업세션시작
     */
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        // 에러가 없어야 넘어감
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            completion(nil)
            return
        }
        // 옵셔널 바인딩
        guard let safeData = data else {
            print("Error: Did not receive data")
            completion(nil)
            return
        }
        // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            completion(nil)
            return
        }
            
        // 원하는 모델이 있다면, JSONDecoder로 decode코드로 구현 ⭐️
        // print(String(decoding: safeData, as: UTF8.self))
        
        // json -> 구조체
        do {
            let decodder = JSONDecoder()
            let musicData = try decodder.decode(MusicData.self, from: safeData)
            completion(musicData.results)
            //dump(musicData.results)
            return
        } catch {
            
        }
    }.resume()
    print("먼저 출력됨")
}

// 실제 API에서 받게 되는 정보
struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}

// 실제 우리가 사용하게될 음악(Music) 모델 구조체
// (서버에서 가져온 데이터만 표시해주면 되기 때문에 일반적으로 구조체로 만듦)
struct Music: Codable {
    let songName: String?
    let artistName: String?
    let albumName: String?
    let previewUrl: String?
    let imageUrl: String?
    private let releaseDate: String?
    
    // 네트워크에서 주는 이름을 변환하는 방법 (원시값)
    // (서버: trackName ===> songName)
    enum CodingKeys: String, CodingKey {
        case songName = "trackName"
        case artistName
        case albumName = "collectionName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
}


@main
struct Main {
    static func main() {
        // MARK: - main 함수가 비동기 작업이 완료될 때까지 대기
        let group = DispatchGroup()
        group.enter()
        
        /*
         콜백함수를 통해 데이터를 전달 받아야
         비동기처리가 끝난 시점에 데이터를 전달 받을 수 있다
         */

        getMethod { musicArray in
            guard let musicArray = musicArray else { return }
            dump(musicArray)
        }
        
        // MARK: - 비동기 작업 완료 대기
        group.wait()
    }
}
