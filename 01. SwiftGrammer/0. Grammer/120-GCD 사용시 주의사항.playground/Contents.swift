/*
 
 (177강)
 GCD 사용시 주의사항
 
 MARK: 비동기적인 처리는 작업이 오래 걸리기 때문에 일부러 비동기적으로 처리한다
 MARK: 비동기적인 처리는 리턴형으로 받는게 아니라 클로저를 통해서 받아야 한다
 MARK: 리턴형으로 설계하면 데이터가 전달될 수 없음
 MARK: 이유: 오래걸리는 끝나는 시점을 코드에서 알 수 없어서 끝나는 시점에 다른 함수를 실행시키는 것이고 그 함수가 클로저다(=completion)

 메모리 누수가 발생되지 않더라도 기본적으로 강한 참조
 -> 클로저의 수명 주기가 길어질 수 있다
 */


//: [Previous](@previous)
import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: # 올바른 비동기함수의 설계
//: ### 리턴(return)이 아닌 콜백함수를 통해, 끝나는 시점을 알려줘야 한다.

//:> 함수(메서드)를 아래처럼 설계하면 절대 안된다.
func getImages(with urlString: String) -> UIImage? {
    
    // MARK: 문자열을 받아서 URL구조체를 만든다
    let url = URL(string: urlString)!
    
    // MARK: photoImage을 nil로 초기화
    var photoImage: UIImage? = nil
    
    // MARK: 구조체로 만든 URL을 전달해서 http 프로토콜을 통해 서버랑 통신을 한다
    // MARK: 결과적으로 데이터를 http 응답 메시지를 벗겨서 내부의 Message Body에 있는 데이터를 클로저로 전달한다
    // MARK: URLSession은 내부적으로 비동기적으로 설계되었다 그래서 이 코드는 기다리지 않고 넘어가서 리턴한다
    // MARK: 그래서 반드시 nil이 나올 수 밖에 없다
    // MARK: 이유: URLSession 자체가 비동기적으로 작동해서
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("에러있음: \(error!)")
        }
        // 옵셔널 바인딩 MARK: data가 옵서녈 타입이라서
        guard let imageData = data else { return }
        
        // 데이터를 UIImage 타입으로 변형
        photoImage = UIImage(data: imageData)
        
    }.resume()

    
    return photoImage    // 항상 nil 이 나옴
}



getImages(with: "https://bit.ly/32ps0DI")    // 무조건 nil로 리턴함 ⭐️






//:> 올바른 함수(메서드)의 설계 - 콜백함수의 사용법
// MARK: 일반적으로 이런 함수의 파라미터를 completionHandler 라고 부른다
func properlyGetImages(with urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
    
    let url = URL(string: urlString)!
    
    var photoImage: UIImage? = nil
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("에러있음: \(error!)")
        }
        // 옵셔널 바인딩
        guard let imageData = data else { return }
        
        // 데이터를 UIImage 타입으로 변형
        photoImage = UIImage(data: imageData)
        
        // MARK: completionHandler 클로저 실행
        completionHandler(photoImage)
        
    }.resume()
    
}

// MARK: 애플이 설계해놓은 대부분의 콜백함수의 이름을 completionHandler 라고 이름을 지어놨음
// MARK: 비동기적인 함수를 실행시킨 다음 결과적으로 일이 끝난 다음 결과를 클로자로 받아서 실행하겠다
// MARK: 일이 일어나고 사후적으로 클로저가 일이 일어난다

// MARK: properlyGetImages()동작하고 <#T##(UIImage?) -> Void#>가 사후적으로 동작한다
// properlyGetImages(with: <#T##String#>, completionHandler: <#T##(UIImage?) -> Void#>)

// 올바르게 설계한 함수 실행
properlyGetImages(with: "https://bit.ly/32ps0DI") { (image) in
    
    // 처리 관련 코드 넣는 곳...
    
    DispatchQueue.main.async {
        // UI관련작업의 처리는 여기서
    }
    
}



sleep(5)



PlaygroundPage.current.finishExecution()
//: [Next](@next)
//Copyright (c) 2021 we.love.code.allen@gmail.com
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
//distribute, sublicense, create a derivative work, and/or sell copies of the
//Software in any work that is designed, intended, or marketed for pedagogical or
//instructional purposes related to programming, coding, application development,
//or information technology.  Permission for such use, copying, modification,
//merger, publication, distribution, sublicensing, creation of derivative works,
//or sale is expressly withheld.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
