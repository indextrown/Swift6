 /*
  
  (53강) 열거형의 기본 개념
  
  열거형
  - 타입이다
  
  언제 열거형을 사용하는가?
  - 코드 가독성, 안전성===>명확한 분기 처리 가능
  
  열거형은 항상 switch문으로 분기 처리 가능
  
  */

enum Weekday {
    case monday
    case tuesday
    case wednesday
    case friday
    case saturday
    case sunday
}

enum CompassPoint {
    case north, south, east, west
}

enum School {
    case elementary
    case middle
    case high
    case university
}

var school: School = School.elementary
var school1 = School.middle



var today: Weekday = Weekday.monday
today = Weekday.friday
today = .monday // 생략가능

// if문 활용
if today == .monday {
    
}

// if문 분기처리
if today == .monday {
    print("오늘은 월요일입니다.")
} else if today == .tuesday {
    print("오늘은 화요일입니다.")
}

switch today {
case Weekday.monday:
    print("오늘은 월요일입니다.")
case .tuesday:
    print("오늘은 화요일입니다.")
case .sunday:
    print("오늘은 일요일입니다.")
default:
    break
}



/*
 
 (54강) 열거형의 원시값과 연관값
 
 원시값
 - 원래의 값, 근본적인 값
 연관값
 - 연관된, 괸련된 값
 
 원시값
 - 열거형의 각각의 case들을 숫자나 문자열과 매칭시켜서 자유롭게 활용하고 싶은 개념이다
 - 열거형 타입에 또다른 숫자를 매칭하는 형태
 - hashable한 타입은 모두 사용 가능함
 
 
 연관값
 - 원시값과 다르게 구체적인 추가정보를 저장하기 위해 사용
 - 카테고리의 역할을 만든다
 - 사용하는 이유: 정보가 바뀔때마다 무한대로 케이스를 만들고 싶을 때 사용
 - 카테고리에 해당하는 구체적인 값을 저장할 때 사용
 

 
 
 */

/**=============================================================================
 - 1) 자료형 선언 방식: 선언하는 위치가 다름
 - 2) 선언 형식: (1) 원시값 ===> 2가지중 1가지 선택 / (2)연관값 ===> 튜플의 형태로 형식 제한 없음
 - 3) 값의 저장 시점: (원시값: 선언시점 / 연관값: 새로운 열거형 값을 생성할때 )
 - 4) 서로 배타적: 하나의 열거형에서 원시값과 연관값을 함께 사용하는 것은 불가능 함
=================================================================================**/

// 원시값
enum Alignment: Int {
    case left   // = 0매칭
    case center // = 1매칭
    case right  // = 2매칭
}

enum Alignment1: Int {
    case left       // = 0매칭
    case center = 3 // 3 매칭
    case right      // = 4매칭
}

enum Alignment2: String {
    case left       // "left"
    case center     // "center"
    case right      // "right"
}
let align = Alignment.left
// 위아래 완전히 동일
var align2 = Alignment(rawValue: 0) // 생성자, left랑 매칭되어있음 즉 left 생성
align2 = Alignment(rawValue: 1)

Alignment.center.rawValue   // 1

Alignment2(rawValue: "left")


// 가위 바위 보 열거형 만들기
enum RpgsGame: Int {
    case rock
    case paper
    case scissors
}

// rock 생성과 생성자를 이용한 생성은 다름
// 생성자로 생성하면 Optional 타입이다
// 생성 안될때는 nil 나와야 하기 때문
RpgsGame(rawValue: 5)
RpgsGame(rawValue: 0)
RpgsGame(rawValue: 1)

// 활용
if let game = RpgsGame(rawValue: 5) {
    print("yes")
} else {
    print("no")
}

let number = Int.random(in: 0...10) % 3 // 무조건 0, 1, 2 중에 나옴
print(RpgsGame.init(rawValue: number)!) // 출력은 하지만 문자열은 아님 주의!


// 행성 열거형 만들기
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

let planet = Planet(rawValue: 2)!
planet.rawValue



// 열거형의 연관값
enum Computer {
    case cpu(core: Int, ghz: Double)
    case ram(Int, String)
    case hardDisk(gb: Int)
}

Computer.cpu(core: 4, ghz: 3.5)
Computer.cpu(core: 8, ghz: 1.5)


var chip = Computer.ram(8, "Dram")

switch chip {
case .cpu(core: 8, ghz: 3.1):
    print("cpu 8코어 3.1GHz 입니다. ")
case .cpu(core: 8, ghz: 2.6):
    print("cpu 8코어 2.6GHz 입니다. ")
case .ram(32, _):   // 32만 일치하면 출력됨
    print("32기가램 입니다. ")
default:
    print("그 이외의 칩에는 관심이 없습니다. ")
}


// 중요개념
// 케이스를 다 나열하지 않고 바인딩을 통해 값을 꺼내서 사용할 수 있다
switch chip {
case .cpu(let a, let b):
    print("CPU \(a)코어 \(b)GHz입니다.")
case let .ram(a, _):
    print("램 \(a)기가램 입니다.")
case .hardDisk(let a):
    print("하드디스크 \(a)기가 용량입니다.")
}
