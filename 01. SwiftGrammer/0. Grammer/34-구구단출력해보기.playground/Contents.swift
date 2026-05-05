// 구구단 출력
for i in 2...9 {
    for j in 1...9{
        print("\(i) * \(j) = \(i*j)")
    }
    print()
}

// 1부터 10까지의 숫자로 3으로 나누어 지는 숫자 즉 3의 배수 출력😀
for i in 1...10 {
    if i % 3 == 0 {
        print("3의 배수 발견: \(i)")
    }
}

// continue 활용
for i in 1...10 {
    if i % 3 != 0 {
        continue    // 3의 주기가 아니면 다음 주기로 넘어감, 걸러낼 때 사용
    }
    print("3의 배수 발견: \(i)")
}

// print(_:separator:terminator:)
// separator: 구분
// terminator: 종료
for i in 1...5 {
    for _ in 1...i {
        print("😀", terminator: "")
    }
    print()
}

// 동일
for i in 1...5 {
    for j in 1...5 {
        if j <= i {
            print("😀", terminator: "")
        }
    }
    print()
}

