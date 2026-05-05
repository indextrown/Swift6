import UIKit



/*
 
 메모리 누수 사례
 - 클래스와 내부에 있는 클로저가 서로를 가르켜서 메모리 누수가 발생할 수 있는 사례
 
 정리
 - 메모리 관리는 rc를 통해서 일어난다
 - 자동으로 해주지만 어떤 상황에서는 알고 써야한다
 - 잘못 쓰면 강한 참조 사이클과 메모리 누수가 발생할 수 있다

 
 */


class Dog {
    var name = "초코"
    
    // 옵셔널 함수형
    var run: (() -> Void)?
    
    func walk() {
        print("\(self.name)가 걷는다.")
    }
    
    func saveClosure() {
        // 클로저를 인스턴스의 변수에 저장
        // 실행하는게 아니라 변수에 저장을 한다
        run = { [weak self] in
            print("\(self?.name)가 뛴다.")
        }
    }
    
    deinit {
        print("\(self.name) 메모리 해제")
    }
}


func doSomething() {
    let choco: Dog? = Dog()
    // choco?.saveClosure()
}

// main 스택프레임에서 doSomething()이 실행되고
// 내부에서 변수가 선언된다
// doSomething2() // 초코 메모리 해제



func doSomething2() {
    let choco: Dog? = Dog()
    choco?.saveClosure() // 이거떄문
}

// doSomething2() // 초코 메모리 해제x

 // 해결방법
//weak self


// 18-10
class ViewController: UIViewController {
    var name: String = "뷰컨"
    
    func doSomething() {
        // 2번cpu에서 일을 시키는것
        DispatchQueue.global().async {
            sleep(3)    // cpu가 3초동안 동작을 멈추는 일
            print("글로벌큐에서 출력하기: \(self.name)")
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}

func localScopeFunction() {
    let vc = ViewController()
    vc.doSomething()
}

localScopeFunction()

/*
 결과
 글로벌큐에서 출력하기: 뷰컨
 뷰컨 메모리 해제
 
 */


//
class ViewController1: UIViewController {
    var name: String = "뷰컨"
    
    func doSomething1() {
        // 2번cpu에서 일을 시키는것
        DispatchQueue.global().async { [weak self] in
            // 1)
            // sleep(3)    // cpu가 3초동안 동작을 멈추는 일
            // print("글로벌큐에서 출력하기: \(self?.name)")
            
            // 2) viewcontroller없어지면 일을 종료시키고싶을때
            guard let weekSelf = self else { return }
            sleep(3)
            print("글로벌큐에서 출력하기: \(weekSelf.name)")
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}

func localScopeFunction1() {
    let vc = ViewController1()
    vc.doSomething1()
}

localScopeFunction1()
/*
 결과:
 뷰컨 메모리 해제
 글로벌큐에서 출력하기: nil
 -> 이미 시라져서 nil 출력됨
 */


