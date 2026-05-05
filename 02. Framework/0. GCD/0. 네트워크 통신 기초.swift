//
//  0. 네트워크 통신 기초.swift
//  Swift5
//
//  Created by 김동현 on 3/11/25.
//

// 영화 진흥위원회 오픈 API
// https://www.kobis.or.kr/kobisopenapi/homepg/main/main.do

// 요청주소
// http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json

//let myKey = "91c037fce2fcb7481f8b8022c4bdc25a"
// http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=91c037fce2fcb7481f8b8022c4bdc25a&multiMovieYn=N&targetDt=20250310


import Foundation
import SwiftUI

@main
struct Main {
    static func main() {
        let myKey = "91c037fce2fcb7481f8b8022c4bdc25a"
        let movieURL = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        
        // 기본 URL 문자열을 사용하여 URLComponents 생성
        var components = URLComponents(string: movieURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: myKey),
            URLQueryItem(name: "multiMovieYn", value: "N"),
            URLQueryItem(name: "targetDt", value: "20250310")
        ]
        
        // 1. URL 구조체 만들기
        //let url = URL(string: "")!
        guard let url = components?.url else {
            print("URL 생성 실패")
            return
        }
        
        // 2. URLSession 만들기(네트워킹을 하는 객체로 - 브라우저 같은 역할이다, 연결상태유지역할)
        let session = URLSession.shared
        
        // MARK: - main 함수가 비동기 작업이 완료될 때까지 대기
        let group = DispatchGroup()
        group.enter()
        
        // 3. 세션에 (일시정지 상태로) 작업 부여
        let task = session.dataTask(with: url) { (data, response, error) in
            
            /*
            guard error == nil else {
                print(error!)
                return
            }
             */
            
            // 에러가 nil이 아니면(발생하면) 종료
            if error != nil {
                print("에러 발생")
                return
            }
            
            // 응답코드가 실패하면 종료
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            guard let safeData = data else {
                return
            }
            
            //print(String(decoding: safeData, as: UTF8.self))
            // dump(parseJSON1(safeData)!)
            
            let movieArray = parseJSON1(safeData)!
            dump(movieArray)
        }
        
        // 4. 작업 시작(일시정지된 상태로 작업이 시작하기떄문)
        task.resume()
        
        
        // MARK: - 비동기 작업 완료 대기
        group.wait()
    }
}


// MARK: - 서버에서 주는 데이터 형테 구조테들
struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let rank: String
    let movieNm: String
    let audiCnt: String
    let audiAcc: String
    let openDt: String
}

// MARK:  받아온 데이터를 우리가 쓰기 좋게 변환하는 과정 (분석) ======================================

// 현재의 형태
func parseJSON1(_ movieData: Data) -> [DailyBoxOfficeList]? {
    do {
        // 스위프트5, 자동으로 원하는 클래스/구조체 형태로 분석
        // JSONDecoder
        let decoder = JSONDecoder() // 데이터 -> code로 변경
        // decoder.decode(변형하고 싶은 형태)
        let decodedData = try decoder.decode(MovieData.self, from: movieData)
        return decodedData.boxOfficeResult.dailyBoxOfficeList
    } catch {
        return nil
    }
}

// 예전의 형태
func parseJSON2(_ movieData: Data) -> [DailyBoxOfficeList]? {
    
    do {
        
        var movieLists = [DailyBoxOfficeList]()
        
        // 스위프트4 버전까지
        // 딕셔너리 형태로 분석
        // JSONSerialization
        if let json = try JSONSerialization.jsonObject(with: movieData) as? [String: Any] {
            if let boxOfficeResult = json["boxOfficeResult"] as? [String: Any] {
                if let dailyBoxOfficeList = boxOfficeResult["dailyBoxOfficeList"] as? [[String: Any]] {
                    
                    for item in dailyBoxOfficeList {
                        let rank = item["rank"] as! String
                        let movieNm = item["movieNm"] as! String
                        let audiCnt = item["audiCnt"] as! String
                        let audiAcc = item["audiAcc"] as! String
                        let openDt = item["openDt"] as! String
                        
                        // 하나씩 인스턴스 만들어서 배열에 append
                        let movie = DailyBoxOfficeList(rank: rank, movieNm: movieNm, audiCnt: audiCnt, audiAcc: audiAcc, openDt: openDt)

                        
                        movieLists.append(movie)
                    }

                    return movieLists

                }
            }
        }

        return nil
        
    } catch {
        
        return nil
    }
    
}

