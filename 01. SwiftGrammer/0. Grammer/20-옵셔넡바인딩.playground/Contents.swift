// optional타입을 벗겨서 사용하려고 if let바인딩, guard let 바인딩 사용한다
var number: Int? = 7
var hello: String? = "안녕하세요"
var name: String? = "홍길동"
var newNum: Double? = 5.5

// 실제로 앱 만들 때는 옵셔널 값을 쓸 수가 없다
// 직접적으로 값을 꺼내서 사용해야 한다


if let num = number {
    print(num)
}

if let hi = hello {
    print(hi)
}

if let n = name {
    print(n)
}

if let num = newNum {
    print(num)
}


// guard let 바인딩을 만들려면 early exit이 필요하기 때문에 함수로 정리할 필요가 있다
func doPrint(num: Int?) {
    guard let n = num else { return }
    print(n)
}
doPrint(num: number)

func doPront2(say: String?) {
    guard let n = say else { return }
    print(n)
}
doPront2(say: hello)





// 옵셔널 파라미터 사용 함수의 정의

func doSomePrint(with label: String, name: String? = nil) {   // String? = nil
    print("\(label): \(name)")
}



// 함수의 실행

//doSomePrint(with: <#T##String#>, name: <#T##String?#>)


doSomePrint(with: "레이블", name: "스티브 잡스")

doSomePrint(with: "레이블", name: nil)

doSomePrint(with: "레이블")
