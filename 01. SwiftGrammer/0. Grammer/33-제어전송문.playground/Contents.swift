// continue
// 반복의 지금 주기 끝내고 다음 반복 주기로 넘어간다

// break
// 반복문을 종료시킨다

// 2의 배수이면 무시한다 = 반복문의 다음 주기로 넘어간다
for num in 1...20 {
    if num % 2 == 0 {
        continue
    }
    print(num)
}

// 1출력하고 num = 2일때 break를 만나서 반복문을 종료시킨다
for num in 1...20 {
    if num % 2 == 0 {
        break
    }
    print(num)
}

for i in 0...3 {
    print("OUTER \(i)")
    
    for j in 0...3 {
        if i > 1 {
            print("    j: ", j)
            //continue  // 가장 인접한 반복문의 주기를 넘어감
            break       // 가장 인접한 반복문을 종료
        }
        print("    INNER \(j)")
    }
}

OUTER: for i in 0...3 {
    print("OUTER \(i)")
    
    for j in 0...3 {
        if i > 1 {
            print("    j: ", j)
            //continue  // 가장 인접한 반복문의 주기를 넘어감
            break       // 가장 인접한 반복문을 종료
        }
        print("    INNER \(j)")
    }
}

