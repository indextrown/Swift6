/*
 
 (102강)
 서브스크립트
 - 대괄호를 이용해 접근가능하도록 만든 문법
 - 특별한 형태의 메서드
 - 메서드이기때문에 직접 구현 가능
 
 배열, 딕셔너리
 arr[0], dictionary["A"]
 
 
 
 
 배열
 - 실제로 구조체로 구현됨
 - 스택에 저장되는가? x
 - 배열자체는 클래스에 존재하기 때문에 클래스가 항상 가지고 있어야함
 - 실질적으로 힙 메모리 공간을 사용해서 저장이 된다
 - 실제 데이터는 배열의 주소를 가리킴
 
 */


var array = [1, 2, 3, 4, 5]
array[0]

// 클래스 만들고 인스턴스를 찍어낸 다음에 인스턴스에서 대괄호를 사용해보고싶다
class SomeData {
    var datas = ["Apple", "Swift", "iOS", "Hello"]
}

var data = SomeData()
// data[3] // 접근 불가
data.datas[3] // 접근가능

// data[3]으로 즉 인스턴스로 접근하고싶다.
// 인스턴스 메서드로써의 서브스크립트 구현
class SomeData2 {
    var datas = ["Apple", "Swift", "iOS", "Hello"]
    
    // 파라미터는 생략 불가, 반드시 값 필요
    subscript(index: Int) -> String {
        get {
            return datas[index]
        }
        set {
            datas[index] = newValue
        }
        /* 이것도 가능
        set(parameterName) {
            datas[index] = parameterName
        }
         */
    }
}

var mydata = SomeData2()
mydata[0]





struct TimesTable {
    // 저장속성
    let multiplier: Int = 3
    
    subscript(index: Int) -> Int {
        return multiplier * index
    }
    
}

// 인스턴스 찍어내기
let thireeTimesTable = TimesTable()
thireeTimesTable[2] // 6나옴 계산속성과 유사

print("6에 3배를 하면 숫자 \(thireeTimesTable[6])가 나옵니다")


struct Matrix {
    // 2차원 배열
    var data = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]
    
    // 2개 파라미터를 받는 읽기전용 서브스크립트 구현
    subscript(row: Int, colum: Int) -> String? {
        if row >= 3 || colum >= 3 {
            return nil
        }
        return data[row][colum]
    }
}

var mat = Matrix()
mat[1, 1]!



// 타입 서브스크립트
enum Planet: Int { // 원시값 부여 -> case들이 원시값들 가짐
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptunr
    
    // 숫자를 주면 열거형을 원시값으로 생성후 강제로 벗김
    // 자기자신을 나타내면 Self사용가능
    /*
    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
     */
    static subscript(n: Int) -> Self {
        return Planet(rawValue: n)!
    }
}


let mars = Planet[2]



