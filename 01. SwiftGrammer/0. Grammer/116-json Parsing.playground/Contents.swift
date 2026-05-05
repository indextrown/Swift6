/*
 
 (171강)

 json viewer
 https://chromewebstore.google.com/detail/json-viewer/gbmdgpbipfallnflgajpaliibnhdgobh?hl=ko
 
 // json를 복사해서 넣으면 알아서 만듬
 https://app.quicktype.io
 
 */


import UIKit

// MARK: 서버에서 주는 json 형태
struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
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

// MARK: 내가 사용하고 싶은 형태
struct Movie {
    let neme: String
    let openDate: String
}

// 받아온 데이터를 우리가 쓰기 좋게 변환하는 과정 (분석) ======================================

// MARK: 2가지 형태
// 현재의 형태
func parseJSON1(_ movieData: Data) -> [DailyBoxOfficeList]? {
    
    do {
        // 스위프트5
        // 자동으로 원하는 클래스/구조체 형태로 분석
        // JSONDecoder
        let decoder = JSONDecoder() // MARK: 데이터를 코드로 변형하는 무언가
        
        
        // Incordable: 구조체나 클래스를 데이터 형태로 변형시켜주는 프로토콜을 의미한다
        // Decordable을 채택해야 JSONDecoder에서 코드를 자동으로 분석할 수 있다!!!
        
        // -> 둘이 합해서 Cordable이라는 프로토콜로 이루어져있음 Cordable만 채택하면(Incordable, Decordable) 둘다 자동채택됨
        
        // decoder.decode(<#T##type: Decodable.Type##Decodable.Type#>, from: <#T##Data#>)
        
        // MARK: self는 붕어빵틀을 의미한다
        // MARK: 붕어빵틀 형태로 변형하고싶다
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

/* ############################################################################################ */



// url 만들기
let mykey = ""


// url 만들기
let movieURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(mykey)&targetDt=20120101"


 
// movieURL을 가지고 URL구조체로 변형한다
let structUrl = URL(string: movieURL)!


// 구조체를 가지고 URLSession에 넣어서 통신을한다
// 통신한 결과가 클로저에 주어진다
// 브라우저를 켜는 것은 Session을 만드는 것이라고 생각하면된다
// Session: 일정 시간동안 브라우저로부터 들어오는 연결상태를 유지하는 기술이나 연결상태
// -> 브라우저의 하나의 탭이라고 생각하자
let task = URLSession.shared.dataTask(with: structUrl) { data, response, error in
    if error != nil {
        print(error!)
        return
    }
    
    // 안전한 데이터 형태로 변환
    guard let safeData = data else {
        print("에러발생")
        return
    }
    
    // 파싱
    let movieArray = parseJSON1(safeData)
    dump(movieArray!)

}
task.resume()



