/*
 
 (159강)
 참조타입 캡처와 캡처리스트
 
 */


class SomeClass {
    var num = 0
}

var x = SomeClass()
var y = SomeClass()

print("참조 초기값(시작값):", x.num, y.num)

                    // strong되있으면 즉 강하게 가리키면 가리키는 상대방의(x) reference counting을 올리게 된다
                    // 강한 참조 사이클 문제 발생의 가능성이 있다(아래 코드에서는 문제 없음)
let refTypeCapture = { [x] in
    print("참조 타입(캡처리스트):", x.num, y.num)
}

/** =====================================
 x - (참조타입) 주소값 캡처, x를 직접참조로 가르킴
 y - 변수를 캡처해서 y변수를 가르킴(간접적으로 y도 동일)
 =====================================**/

x.num = 1
y.num = 1

// 결과적으로 동일한 객체를 가리켜서 같은 값이 나온다
print("참조 초기값(숫자변경후):", x.num, y.num)   // 1 1
refTypeCapture()                            // 1 1
print("참조 초기값(클로저실행후):", x.num, y.num)  // 1 1





// 인스턴스 가리키는 경우 강한 참조 사이클 문제 발생 가능성 존재
// 강한 참조 사이클 문제 해결법: 캡처리스트 + weak/unowned
var z = SomeClass()

                        // 생략하면strong
let refTypeCulture1 = { [weak z] in
    print("참조 초기값(캡처리스트):", z?.num)  // 1 1
}

var s = SomeClass()

let captureBinding = { [z = s] in
    print("바인딩의 경우:", z.num)
}

let captureWeakBinding = { [weak z = s] in
    print("Weak 바인딩의 경우:", z?.num)
}

