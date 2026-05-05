import UIKit
/*
 (154강)
 옵셔널 타입의 응용(8단원)
 
 옵셔널 체이닝
 - 속성을 확인하기위해 점 접근연산자를 사용할때 앞에있는타입이 옵셔널 타입이라면 반드시 물음표를 붙여서 체이닝을 해야한다
 - 옵셔널 타입에 대해 점 접근연산자를 호출하는 방법을 의미
 - 옵셔널 체이닝의 결과는 항상 옵셔널이다--> 물음표가 하나라도 붙으면 결과는 옵셔널로 나오는것을 유의해라
 - 옵셔널체이닝에 값 중에서 하나라도 nil을 리턴한다면 이어지는 표현식은 평가하지 않고 nil을 리턴
 
 
 함수가 리턴형이 있는 경우(잘 안만나는 케이스)
 - 타입에 값이 있으면 옵셔널 리턴 타입으로 반환(원래 리턴 형이 옵셔널이 아니더라도)
 - 타입에 값이 없으면 nil로 반환
 */

// 옵셔널 체이닝 문법
class Dog {
    var name: String?   // 옵셔널스트링: 초기값 없으면 nil로 세팅된다
    var weight: Int
    
    init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }
    
//    func sit() {
//        if let name = self.name {
//            print("\(name)가 앉았습니다.")
//        }
//    }
    func sit() {
        print("\(self.name)가 앉았습니다.")
    }
    
    func layDown() {
        print("누웠습니다.")
    }
}


class Human {
    var dog: Dog? // dog이 있으면 Dog, 없으면 nil로 초기화
}

// 붕어빵 찍어내는 코드
// choco변수는 stack에, 붕어빵 Dog(name: "초코", weight: 15)는 heap영역에 존재
var choco = Dog(name: "초코", weight: 15)
print(choco.name)     // 옵셔널 초코
choco.sit()

// 물음표가 붙는다 = 옵셔널 체이닝과 관련된 문법이다
// 왜 물음표가 붙는가?
// choco2의 타입이 옵셔널의 가능성이 있는 경우에 점문법을 사용한다
// 점문법을 사용시 물음표를 붙여서 변수의 타입이 옵셔널의 가능성이 있다는 것을 반드시 써줘야한다 == 옵셔널 체이닝과 관련된 문법
// choco2라는 변수의 타입이 Optional Dog이기때문에 반드시 옵셔널 타입이고 점문법 사용시 점문법 앞에 물음표를 해주는게 문법적인 약속이다
// 물음표를 생략하면 에러가 난다
var choco2: Dog? = Dog(name: "초코", weight: 15)
choco2?.name
choco2?.sit()

var human = Human()
human.dog = choco
human.dog?.name


var human2 = Human()
human2.dog = choco  // 붕어빵을 할당하고있다 human의 dog에는 choco가 있다
human2.dog?.name    // 이름 확인, 앞에있는 dog속성이 옵셔널 속성이라서 이름 확인시 물음표를 붙혀줘야함
// human2.dog?.name?   // 마지막 점뒤의 속성은 옵셔널이라도 물음표 필요 없다

print(human.dog?.name)


// human3는 옵셔널 타입이 된다
var human3: Human? = Human()
// human3변수는 옵셔널 타입이라 ? 붙혀야한다 문법적 약속이다
human3?.dog = choco
human3?.dog?.name // human3, dog 둘다 옵셔널 타입이라 물음표 2개 필요하다--> 옵셔널체이닝


if let n = human3?.dog?.name {
    print(n)
}

// 옵셔널체이닝에 값 중에서 하나라도 nil을 리턴한다면 이어지는 표현식은 평가하지 않고 nil을 리턴
//human3 = nil
human3?.dog = nil
print(human3?.dog?.name)


// Nil-Coalescing 연산자 ??
// 기본값을 제시할수있는 경우의 우아하게 벗길 수 있는 옵셔널 바인딩과 유사한 문법이라고 생각하자
// 무조건 문자열이 나온다--> nil이면 멍탱구리를 넣어버려서
var defaultName = human3?.dog?.name ?? "멍탱구리"
print(defaultName)


// 타입이 옵셔널이면 물음표를 사용해야한다
//var choco3: Dog? = Dog()
//choco?.name = "초코"
//print(choco3?.name)
//choco3?.sit()



// 활용예시
class Cat {
    // 문자열 스트링
    var name: String?
    // 타입: 함수타입으로 정의되어있음
    // 함수타입인데 소괄호로 물음표르 붙혔음
    // 옵셔녈 함수이다(함수가 있을수도 or nil이 있을수도)
    // 옵셔널 클로저
    var myMaster: (()-> Person?)?
    
    // 함수의 실행 흐름을 벗어난다
    // () -> Person? 함수가 변수에 저장되면서 스택프레임을 벗어난다 이럴때 클로저를 사용한다
    // 생성자의 흐름을 탈출해서 @escaping 키워드 필요하다
    // 함수를 변수에 저장하니까 당연히 자동적으로 @escaping 키워드 필요하다고 생각해도됨
    init(aFunction: @escaping () -> Person?) {
        self.myMaster = aFunction
    }
}

class Person {
    var name: String?
}

func meowmeow() -> Person? {
    let person = Person()
    person.name = "jobs"
    return person
}

// 함수를 사용해서 붕어빵을 찍어내고 cat에 담고있다
// 변수 cat에는 cat이 있을수도 또는 nil일수도
var cat: Cat? = Cat(aFunction: meowmeow)

// () 앞뒤의 ? 의미 다름
// () 앞의 물음표: 함수가 없을수도 있다는 뜻
// () 뒤의 물음표: Person이 없을 수도 있다는 뜻
// -> 즉 meowmeow함수가 Optional Person으로 리턴하기 떄문에 nil을 리턴할 수도 있음
// -> 함수의 결과값이 nil일수도있다 즉 없을수도 있다
var name = cat?.myMaster?()?.name

if var name = cat?.myMaster?()?.name {
    print(name)
}






class Library1 {
    // 옵셔널 딕셔너리(즉 딕셔너리가 있을수도 없을수도 있다)
    var books: [String: Person]?
}

var person1 = Person()
person1.name = "jobs"
print(person1.name)



var person2 = Person()
person2.name = "Musk"
print(person2.name)


var library = Library1()
library.books = ["Apple": person1, "Tesla": person2]
library.books?["Apple"]?.name


// [] 앞의 물음표: 딕셔너리가 없을 수도 있다
// [] 뒤의 물음표: 딕셔너리의 값이 없을 수도 있다
// -> 딕셔너리는 키값을 가지고 서브스크립트에서 사용하는데 "ABC"와 같이 없난 key 접근하면 결과값이 없을 수 있음 이런 경우 에러발생해서 nil이 나올 수 있도록 해줘야한다




if let name = library.books?["Apple"]?.name {
    print(name)
}


// 옵셔녈 체이닝에서 함수의 실행은 어떻게 될까?
/*
 옵셔널 타입에 접근해서 사용하는 함수는
 (앞의 타입을 벗기지 않아도 사용가능함, 다만 함수자체가 옵셔널 타입은 아니기 떄문에 함수를 벗겨서 사용할 필요없음)
 
 
 */
var bori: Dog? = Dog(name: "보리", weight: 20)
// 굳이 메서드의 실행은 이렇게 할 필요 없다는 의미
// -> 이유: bori가 nil이면 메서드를 실행하지 않고 nil을 리턴해준다
// -> bori에 값이 있으면 그대로 사용한다

//if let b = bori {
//    b.sit()
//    b.layDown()
//}


// 값이 없으면 nil 리턴, 값이 있으면 함수 실행
// 굳이 !쓸필요x
bori?.sit()
bori?.layDown()

bori = nil
bori?.sit()
bori?.layDown()
















