//
//  0. 네트워크 통신 기초.swift
//  Swift5
//
//  Created by 김동현 on 3/11/25.
//



import Foundation
import SwiftUI

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

// MARK: - 서버에서 분석한걸 변형해서 나의 앱에서 만들고 싶은 데이터
struct Movie {
    // 타입속성
    static var movieId: Int = 0
    let movieName: String
    let rank: Int
    let openDate: String
    let todayAudience: Int
    let totalAudience: Int
    
    init(movieNm: String, rank: String, openDate: String, audiCnt: String, accAudi: String) {
        self.movieName = movieNm
        self.rank = Int(rank)!
        self.openDate = openDate
        self.todayAudience = Int(audiCnt)!
        self.totalAudience = Int(accAudi)!
        Movie.movieId += 1
    }
}


// 서버와 통신
struct MovieDataManager {
    let myKey = "91c037fce2fcb7481f8b8022c4bdc25a"
    let movieURL = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    
    // 영화 정보 수집 함수
    func ferchMovie(date: String, completion: @escaping (([Movie]?) -> Void)) {
        // 기본 URL 문자열을 사용하여 URLComponents 생성
        var components = URLComponents(string: movieURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: myKey),
            URLQueryItem(name: "multiMovieYn", value: "N"),
            URLQueryItem(name: "targetDt", value: date)
        ]
        
        performRequest(components!) { movies in
            completion(movies)
        }
    }
    
    // 실제 수행 로직(call back 함수: 통신결과를 영화데이터 배열로 넘겨주겠다)
    func performRequest(_ urlComponent: URLComponents, completion: @escaping (([Movie]?) -> Void)) {
        
        // 1. URL 구조체 만들기
        guard let url = urlComponent.url else { return }
            
        // 2. URLSession 만들기(네트워킹을 하는 객체 - 브라우저 역할)
        let session = URLSession(configuration: .default)
        
        // 3. 세션에 작업 부여
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                completion(nil)
            }
            
            guard let safeData = data else {
                completion(nil)
                return
            }
            
            // 데이터 분석하기
            if let movies = self.parseJSON(safeData) {
                completion(movies)
            } else {
                completion(nil)
            }
        }
        
        // 4. task 진행(일시정지된 상태로 작업이 시작하기 떄문에 해준다)
        task.resume()
    }
    
    // MARK:  받아온 데이터를 우리가 쓰기 좋게 변환하는 과정 (분석) ======================================
    func parseJSON(_ movieData: Data) -> [Movie]? {
        do {
            // 스위프트5, 자동으로 원하는 클래스/구조체 형태로 분석
            let decoder = JSONDecoder() // 데이터 -> code로 변경
            
            // decoder.decode(변형하고 싶은 형태)
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            
            let dailyLists = decodedData.boxOfficeResult.dailyBoxOfficeList
            
            /*
             반복문으로 movie 배열 생성
            var myMovieLists = [Movie]()
             
            for movie in dailyLists {
                let name = movie.movieNm
                let rank = movie.rank
                let openDate = movie.openDt
                let todayAudi = movie.audiCnt
                let accAudi = movie.audiAcc
                
                let myMovie = Movie(movieNm: name, rank: rank, openDate: openDate, audiCnt: todayAudi, accAudi: accAudi)
                myMovieLists.append(myMovie)
            }
             */
            
            let myMovieLists = dailyLists.map {
                Movie(movieNm: $0.movieNm, rank: $0.rank, openDate: $0.openDt, audiCnt: $0.audiCnt, accAudi: $0.audiAcc)
            }
            return myMovieLists
        } catch {
            return nil
        }
    }
}


@main
struct Main {
    static func main() {
        
        // MARK: - main 함수가 비동기 작업이 완료될 때까지 대기
        let group = DispatchGroup()
        group.enter()
        
        
        // MARK: - 앱 개밠 뷰 컨트롤러에서 일어나는 일
        // 빈 배열
        var downloadedMovies = [Movie]()
        
        // 데이터를 다운로드 및 분석/변환하는 구조체
        let movieManager = MovieDataManager()
        
        // 실제 다운로드 코드
        movieManager.ferchMovie(date: "20250310") { movies in
            if let movies = movies {
                // 배열을 받아서 빈 배열에 넣기
                downloadedMovies = movies
                dump(downloadedMovies)
                
                print("전체 영화 갯수: \(Movie.movieId)")
            } else {
                print("nil")
            }
        }
        
        
        // MARK: - 비동기 작업 완료 대기
        group.wait()
    }
}



