/*
 (165강)
 에러를 던지는 함수를 처리하는 함수
 
 */

enum SomeError: Error {
    case aError
}


func throwingFunc() throws {
    throw SomeError.aError
}

do {
    try throwingFunc()
} catch {
    print(error)
}

// 일반적인 함수로 처리
func handleError() {
    do {
        try throwingFunc()
    } catch {
        print(error)
    }
}

// throwing 함수로 에러 다시 던지기
// 함수 내에서 에러를 직접처리하지 못하는 경우, 에러를 다시 던질 수 있음
// do도 없애도됨
func handleError1() throws {
    do {
        try throwingFunc()
    } // catch블럭이 없어도 에러를 밖으러 던질 수 있다
}



/*
 rethrowing함수로 에러 다시 던지기
 - 에러를 던지는 throwing함수를 파라미터로 받는 경우, 내부에서 다시 에러를 던지기 가능
 */

// 다시 에러를 던지는 함수
// callback함수: 함수의 파라미터로 사용하면서 callback받는다
// 즉 어떤 상황이 됬을 때 나를 다시 호출하는 함수를 의미한다
// 즉 고차함수이다
// 고차함수는 함수를 파라미터로 사용하거나 파리미터를 아웃풋으로 던질 수 있는 함수이다
// 파라미터로 사용되는 함수는 callback함수이다
func someFunction1(callback: () throws -> Void) rethrows {
    try callback()      // 에러를 다시 던짐(직접 던지지 못함)
}


// 방법2
// rethrows 쓰는 이유: 파라미터로 throwing function을 사용하기 때문
func someFunction2(callback: () throws -> Void) rethrows {
    // 에러를 다시 정의
    enum ChangedError: Error {
        case cError
    }
    
    do {
        try callback()
    } catch {
        throw ChangedError.cError// 단순 에러를 변환해서 다시 던짐
    }
}




do {
    try someFunction1(callback: throwingFunc)
} catch {
    print(error)
}

do {
    try someFunction2(callback: throwingFunc)
} catch {
    print(error)
}



// 메서드나 생성자에 throw 키워드 적용 가능
enum NameError: Error {
    case noName
}

class Course {
    var name: String
    
    init(name :String) throws {
        // 빈문자열이면 NameError.noName 에러를 던지도록 생성자를 정의
        if name == "" {
            throw NameError.noName
        } else {
            self.name = name
            print("수업을 올바르게 생성")
        }
    }
}

// 에러 처리(생성자에 대한)
do {
    var course = try Course(name: "스위프트클래스")
    print(course.name)
} catch NameError.noName {
    print("객체가 생성되지 않음")
}


// 에러 처리됨
do {
    var course = try Course(name: "")
    print(course.name)
} catch NameError.noName {
    print("객체가 생성되지 않음")
}


//
class NewCourse: Course {
    override init(name: String) throws {
        try super.init(name: name)// 에러를 발생시킬 수 있는 함수라서 throws 필요하다
    }
}
