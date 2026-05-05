/*
 
 (170강)
 iOS에서 데이터를 받기 위한 요청은 4단계이다
 1) URL 구조체를 만든다
 2) URL Session을 만든다
 3) Session에 있는 메서드, 데이터 태스크 등, 일을 처리하는 실제로 http 요청 메소드를 보내는 데이터 태스크를 가지고 작업을 정의
 4) 실제로 시작
 
 */

import UIKit


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
URLSession.shared.dataTask(with: structUrl) { data, response, error in
    if error != nil {
        print(error!)
        return
    }
    
    if let safeData = data {
        // print(String(String(decoding: safeData, as: UTF8.self)))
        
        // 데이터를 우리가 사용하려는 형태(구조체/클래스)로 변형해서 사용
    }
}


 
let task = URLSession.shared.dataTask(with: structUrl) { data, response, error in
    if error != nil {
        print(error!)
        return
    }
    
    
    // 응답 메시지를 HTTPURLResponse로 타입 캐스팅 한 다음에 response에 담는다
    // response에는 응답코드가 담겨있다
    // 해당 범위 안에 있으면 성공이다 200 ..< 299
    // 꼭 안써도됨
    guard let response = response as? HTTPURLResponse, (200 ..< 299) ~=
        response.statusCode else {
        print("Error: HTTP request failed")
        return
    }
    
    guard let safeData = data else {
        return
    }
    
    print(String(decoding: safeData, as: UTF8.self))
    
}


task.resume()





