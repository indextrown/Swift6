/*
 
 제어전송문 5가지
 - break        switch/반복문
 - fallthrough  switch
 - continue     반복문
 - return       함수
 - throw        (에러가 발생할 수 있는) throwing 함수에서 사용
 
 break
 - switch문의 case에 해당하는 거에서 아무것도 안하면 break 해줘야함
 - 반복문에서는 가장 인접한 반복문을 깨버린다 = 중지시킨다
 
 fallthrough
 - switch문에서 사용
 - 사용 잘 안한다
 - 특정 케이스에 해당할 때 그 일을 하고 그 다음 케이스 일도 시키고 싶을때 사용
 
 continue
 - 반복문에서 다음 주기로 넘어가서 일을 하겠다
 
 return
 - 반복문을 끝낼 때
 - 함수를 끝낼 때
 
 
 */

var a = 2
switch a {
case 1:
    break
case 2:
    print(a)
default:
    print("0")
}


for index in 1...5 {
    if index == 3 {
        break
    }
}

// fallthrough
switch a {
case 1:
    print(1)
case 2:
    print(2)
    fallthrough
case 3:
    print(3)
default:
    break
}


for i in 1...10 {
    if i % 2 == 0 {
        continue
    }
    print(i)
}
