/*
 
 (187강)
 
 
 */


import UIKit

/*:
 ## 네트워킹 코드에서 Result타입
 * 네트워킹 코드에서의 활용
 ---
 */

enum NetworkError: Error {
    case someError
}


//:> Result 타입 사용하기 전
// 튜플타입을 활용, 데이터 전달


// MARK: 네트워킹 결과를 전달하기 위해 Data 또는 NetworkError 2가지 전부 전달해야함
// MARK: 비동기 함수 설계시 리턴형으로 설계하면 안됨
// MARK: 두가지를 전달하고싶으면 콜백함수를 만들어서 콜백함수가 동작하게 하면서 데이터를 전달하게 하면 된다
// MARK: 콜백함수를 처리할 수 있도록 콜백함수를 파라미터로 사용하는것-> 일이 다 끝난 시점에 콜백함수를 호출한다
func performRequest(with url: String, completion: @escaping (Data?, NetworkError?) -> Void) {
    
    guard let url = URL(string: url) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if error != nil {
            print(error!)    
            
            // MARK: 일이 끝나는 시점// 에러가 발생했음을 출력
            // MARK: 에러가 나면 데이터는 nil 전달하고 someError를 전달한다
            completion(nil, .someError)   // 에러가 발생했으니, nil 전달
            return
        }
        
        // MARK: 콜백함수를 호출하는 코드
        // MARK: 옵셔널 바인딩 실패하는 경우 데이터는 nil 전달하고 someError를 전달한다
        guard let safeData = data else {
            
            // MARK: 일이 끝나는 시점
            completion(nil, .someError)   // 안전하게 옵셔널 바인딩을 하지 못했으니, 데이터는 nil 전달
            return
        }
    
        // MARK: 일이 끝나는 시점
        // MARK: 옵셔널 바인딩이 된 에러를 전달??
        completion(safeData, nil)
        
    }.resume()
}



performRequest(with: "주소") { data, error in
    // 데이터를 받아서 처리
    if error != nil {
        print(error!)
    }
    
    // 데이터 처리 관련 코드
    
}



//:> Result 타입 사용 후

func performRequest2(with urlString: String, completion: @escaping (Result<Data,NetworkError>) -> Void) {
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print(error!)                     // 에러가 발생했음을 출력
            // MARK: Result.failure에서 Result 생략 가능
            completion(Result.failure(.someError))  // 실패 케이스 전달
            return
        }
        
        guard let safeData = data else {
            completion(.failure(.someError))   // 실패 케이스 전달
            return
        }
    
        completion(.success(safeData))      // 성공 케이스 전달
       
        
    }.resume()
}



// MARK: result 즉 파라미터 하나로 바뀜
// MARK: result타입은 내부에 성공, 실패를 담을 수 있기 때문
performRequest2(with: "주소") { result in
    switch result {
    // MARK: 실패인 경우 에러를 꺼낼 수 있다
    case .failure(let error):
        print(error)
    case .success(let data):
        // 데이터 처리 관련 코드
        break
    }
}

