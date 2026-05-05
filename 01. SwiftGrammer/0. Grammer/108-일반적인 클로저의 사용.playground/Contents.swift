/*
 
 (180강)
 일반적인 클로저의 사용
 
 실제로 앱을 만드는 방식: 객체 안에 클로저 존재
 
 지금까지는 cpu가 하나라고 가정하고 동작하는 코드를 짜왔다
 1번 cpu가 아니라 2번 cpu에서 동작하게 하는 코드
 
 클로저 내에서 객체의 속성 및 메서드에 접근 시에는 self 키워드를 반드시 사용해야한다
 - 일반적인 함수에서는 self.name은 굳이 안써도 되었음
 - 클로저 내에서는 self.name 즉 객체 속성 및 메서드 접근시 self키워드 반드시 사용해애한다
 방식
 - 1) self.name
 - 2) [self] ===> swift 5.3이후
 
 - 구조체의 경우, self를 생략하는 것도 가능(Swift 5.3이후)
 
 
 */
import UIKit

class Dog {
    var name = "초코"
    
    func doSomething() {
        // 비동기적으로 실행하는 클로저
        // 해당 클로저는 오래동안 저장할 필요가 있음        ==> 새로운 스택을 만들어서 실행하기 때문
        // 2번 cpu(실질적으로 thread)에 일을 시키는 코드  ==> 일을 분리해서 동시에 일을 처리할 수 있다
        // 해당 클로저는 오래동안 저장할 필요가 있음        ==> 새로운 스택을 만들어서 실행하기 때문
        
        // 1)번방식
        DispatchQueue.global().async { 
            // 클로저
            print("나의 이름은 \(self.name)입니다.")
        }
        
        // 2)번방식
        DispatchQueue.global().async { [self] in
            // 클로저
            print("나의 이름은 \(name)입니다.")
        }
    }
}

var choco = Dog()
choco.doSomething()

  
// ⭐️ 클로저를 객체 내에서 사용할때는 대부분 weak과 함께 사용한다고 보면 됨


class Person {
    let name = "홍길동"
    
    func sayMyName() {
        print("나의 이름은 \(name)입니다.")
    }
    
    // self를 통해 강한 참조를 한다
    // 홍길동이라는 인스턴스를 강하게 가리키고 있다
    // 강하게 가르키는 이유: 출력을 해야 하기 떄문에 출력하는 일을 할려면 인스턴스를 가르키고 있어야 한다(오래동안 붙잡아 두기 위해서)
    // 이 일은 두번째 스택에서 이루어진다
    func sayMyName1() {
        DispatchQueue.global().async {
            print("나의 이름은 \(self.name)입니다.")
        }
    }
    
    // 약한 참조를 통해 인스턴스를 가리키고 있어서 RC가 오르지 않는다
    func sayMyName2() {
        DispatchQueue.global().async { [weak self] in
            print("나의 이름은 \(self?.name)입니다.") // 타입이 옵셔널 타입으로 바뀐다
        }
    }
    
    // 앞으로 많이 쓰는 방식 예정
    // weak으로 선언시 guard문을 통해 early exit을 시켜준다
    // guard문을 자주 사용한다
    func sayMyName3() {
        DispatchQueue.global().async { [weak self] in
            // weakSelf관례 벗겨낸다
            // 벗겨지는 경우에만 이름을 출력하겠다
            guard let weakSelf = self else { return }   // 가드문 처리 ==> 객체없으면 일종료
            print("나의 이름은 \(weakSelf.name)입니다.(가드문)")
        }
    }
}


let person = Person()

person.sayMyName()
person.sayMyName1()
person.sayMyName2()
//person.sayMyName3()
