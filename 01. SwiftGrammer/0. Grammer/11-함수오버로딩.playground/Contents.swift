// 개발자가 쓰기 쉽게 만들어둠
// 모든 함수를 외울 필요 줄임
// 함수 이름을 재사용할 수 있다
// overload: 과적하다, 하나의 이름에 여러 함수를 과적하다
func doSomething(value: Int) {
    print(value)
}

func doSomething(value: Double) {
    print(value)
}

func doSomething(value: String) {
    print(value)
}

func doSomething(_ value: String) {
    print(value)
}

func doSomething(value1: Int, value2: Int) {
    print(value1, value2)
}



doSomething(value: "hello")
