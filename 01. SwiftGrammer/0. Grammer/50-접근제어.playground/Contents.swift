/*
 
 (103강)
 은닉화
 - 장점: 다른 개발자가 임의로 바꿀 수 없음
 - 메서드를 이용해서 바꿀 수 있음
 - 외부에서 직접적으로 접근 불가능하게 만들 수 있음
 

 
 싱글톤
 - 앱 구현시 유일하게 한개만 존재하는 객체가 필요한 경우에 사용
 - 클래스를 통해 인스턴스를 한개만 필요한 경우가 앱 개발시 많이 사용됨
 - 한번 생성된 이후에는 앱이 종료될떄까지, 유일한 객체로 메모리에 상주
 - 변수로 접근하는 순간 lazy(지연저장속성)하게 동작하며, 메모리(데이터 영역)에 올라감
 
 
 */


class SomeClass {
    // 저장속성을 인스턴스.name로 접근 불가 == 은닉화
    private var name = "이름"
    
    func nameChange(name: String) {
        self.name = name
    }
    func printName() -> String {
        return self.name
    }

}

var s = SomeClass()
s.nameChange(name: "홍길동")
print(s.printName())






// 싱글톤

class Singleton {
    // 타입 프로퍼티(전역변수)로 선언
    static let shared = Singleton() // 자기자신을 생성
    var userInfoId = 12345
    
    // 새로운 객체 못만들게 하기위해 private 생성자 만들어주면됨
    private init(){}
}

// 접근하는 순간 클래스에서 붕어빵을 하나만 찍어서 heap 영역에 존재하게됨
Singleton.shared


let object = Singleton.shared

object.userInfoId = 1234567
Singleton.shared.userInfoId


let object2 = Singleton.shared
object2.userInfoId

Singleton.shared.userInfoId
// 동일한 객체를 가리키고있음



// 12345가됨 이유: 붕어빵을 새로 찍어냄
// 이렇게 새로운 객체 못만들게 하기위해 private 생성자 만들어주면됨
//let object3 = Singleton()
// object3.userInfoId



// 실제 사용 예시
// 앱 네에서 유일하게 하나만 존재해야하는 객체
let screen = UIScreen.main    // 화면
let userDefaults = UserDefaults.standard    // 한번생성된 후, 계속 메모리에 남음!!!
let application = UIApplication.shared   // 앱
let fileManager = FileManager.default    // 파일
let notification = NotificationCenter.default   // 노티피케이션(특정 상황, 시점을 알려줌)

