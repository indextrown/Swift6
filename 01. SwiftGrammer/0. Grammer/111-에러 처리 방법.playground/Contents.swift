import UIKit

enum HeightError: Error {
    case maxHeight
    case minHeight
}

func checkingHeight(height: Int) throws -> Bool {
    if height > 190 {
        throw HeightError.maxHeight
    }
    else if height < 130 {
        throw HeightError.minHeight
    }
    else {
        if height >= 160 {return true}
        else {return false}
    }
}

/* ======================================
 1) 에러 정식 처리 방법
 ====================================== */

do {
    // 변수에 담는다
    let isChecked = try checkingHeight(height: 200)
    
    if isChecked {
        print("청룔열차 가능")
    } else {
        print("후룸라이드 가능")
    }
} catch {
    print("놀이기구 타는 것 불가능")
}


/* ======================================
 2) try?(옵셔널 트라이) ==> 옵셔널 타입으로 리턴
 - 정상적인 경우 => (정상)라턴타입으로 리턴
 - 에러가 발생하면 => nil 리턴
 ====================================== */
let isChecked: Bool? = try? checkingHeight(height: 160)

if let result = isChecked {
    print(result)
}


/* ======================================
 3) try! (Forced 트라이) ==> 에러가 날 수 없는 경우에만 사용 가능
 - 정상적인 경우 => (정상)리턴타입으로 리턴
 - 에러가 발생하면 => 런타임에러 = 앱꺼짐
 ====================================== */
let isChecked2: Bool = try! checkingHeight(height: 160)



/*
 catch 블럭 처리법
 catch블럭은 do블럭에서 발생한 에러만을 처리하는 블럭
 모든 에러를 반드시 처리해야함(글로벌 스코프에서는 모든 에러를 처리하지 않아도 컴파일 에러발생하지 않는다)
 */

do {
    let isChecked = try checkingHeight(height: 100)
    print("놀이기구 타는 것 가능: \(isChecked)")
} catch HeightError.maxHeight {
    print("키가 커서 놀이기구 타는 것 불가능")
} catch HeightError.minHeight {
    print("키가 작아서 놀이기구 타는 것 불가능")
}
 
// where절 추가 가능
//do {
//    let isChecked = try checkingHeight(height: 100)
//    print("놀이기구 타는 것 가능: \(isChecked)")
//} catch HeightError.maxHeight // where~~{
//    print("키가 커서 놀이기구 타는 것 불가능")
//} catch HeightError.minHeight {
//    print("키가 작아서 놀이기구 타는 것 불가능")
//}
// 

// catch문 안에는 error라는 상수가 제공된다


do {
    let isChecked = try checkingHeight(height: 100)
    print("놀이기구 타는 것 가능: \(isChecked)")
} catch {
    // let error를 자동으로 제공함
    print(error)
    // Error프로토콜에 존재. 앱에서 설정된 언어로 오류를 출력한다
    print(error.localizedDescription)
    
    // 프로토콜 타입 캐스팅 구체적
    if let error = error as? HeightError {
        switch error {
        case .maxHeight:
            print("키가 커서 놀이기구 타는 것 불가능")
        
        case .minHeight:
            print("키가 작아서 놀이기구 타는 것 불가능")
        }
    }
}


// swift 5.3 버전 업데이트
// 케이스 나열도 가능해짐
