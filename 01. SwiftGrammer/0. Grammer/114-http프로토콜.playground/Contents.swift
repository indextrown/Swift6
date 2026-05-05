/*
 (168강)
 API
 - 서버랑 통신을 하기 위해 약속을 정해 놓은것
 -> 네트워크 주소로 get 메서드로 요청해라~
 
 - 애플이 미리 만들어놔서 우리가 쉽게 사용할 수 있는 함수
 -> print()함수

 
 (168강)
 iOS 에서의 네트워킹
 */


import UIKit

let mykey = ""

let movieURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(mykey)&targetDt=20120101"




// 문자열을 가지고 구조체로 바꾸어준다 그리고 붕어빵을 찍어서 structUrl에 담는다
// url타입의 주소를 만들었다
let structUrl = URL(string: movieURL)!

// url세션을 만들어냄
// let session  = URLSession(configuration: .default)

// 싱글톤(객체가 유일하게 메모리에서 반드시 하나만 존재하도록 함) 객체
let session = URLSession.shared


// 예시
func doSomething(num: Int, completion: (Int) -> Void) {
    let n = num + 5
    completion(n)
}

// c는 8이 들어감
//doSomething(num: 3) { c in
//    <#code#>
//}


let task = session.dataTask(with: structUrl) { data, response, error in
    if error != nil {
        print(error!)
        return
    }
    
    // 에러가 없으면
    if let safeData = data {
        // print(safeData) 알아보기 어려움
        
        // 읽을 수 있는 문자열로 받는 방법
        // swift how to print data as string
        let str = String(decoding: safeData, as: UTF8.self)
        print(str)
        
        
    }
}

task.resume()


//session.dataTask(with: structUrl) { data, response, error in
//    if error != nil {
//        print(error!)
//        return
//    }
//    
//    // 에러가 없으면
//    if let safeData = data {
//        // swift how to print data as string
//        print(String(decoding: safeData, as: UTF8.self))
//        
//        // print(safeData)
//    }
//}.resume()


