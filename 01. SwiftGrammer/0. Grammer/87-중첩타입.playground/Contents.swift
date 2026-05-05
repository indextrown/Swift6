import UIKit
/*
 
 (137강)
 메서드 디스패치

 
 */

struct Mystruct {
    // method1()은 컴파일 시점에 cpu가 읽을 수 있는 컴퓨터 언어로 바뀐다
    // method1()은 cpu가 실행될 수 있는 명령어 형태로 바뀐다
    // ex) 실제로 나의 눈에는 print() 한줄이지만 메모리 주소가 90번부터 9줄로 이루어져있다고 가정
    // memory: 90 ~ 99
    func method1() {
        print("Struct - Direct method1")
    }
    
    // memory: 100 ~ 109
    func method2() {
        print("Struct - Direct method2")
    }
}

let myStruct = Mystruct()
// 이코드가 컴파일 되는 시점에 메모리 주소가 각각 90, 100이 들어가게된다
// 즉 구조체인 경우 메서드를 실행하는 코드를 넣으면 실제로 메모리 주소를 삽입해버린다 = direct dispatch
myStruct.method1()  // 90
myStruct.method2()  // 100


// class는 조금 다름
// table dispatch = 동적 디스패치
// virtual table를 사용한다
// 데이터 영역에 테이블을 만들어서 메모리 주소를 저장한다
class FireClass {
    func method1() { print("Class - Table method1") }   // 110 ~ 119
    func method2() { print("Class - Table method2") }   // 120 ~ 129
}

// 실제로 컴퓨터에 실행되는 명령어 동작은 코드 영역에 저장됨
// 데이터 영역에서 클래스를 상속하는 구조들을 만들어서 이 구조들이 코드의 명령어를 가리키고 있다
// 이러한 테이블은 데이터 영역에 생성되고 110번째 메모리 주소가 들어있다
// ###########################################################
// 110
// func method1() { print("Class - Table method1") }
// 129
// func method2() { print("Class - Table method2") }
// ###########################################################

// 자식클래스에서 테이블을 따로 보유
class SecondClass: FireClass {
    override func method2() { print("Class - Table method2-2") } // 130 ~ 139   // 재정의
    func method3() { print("Class - Table method3") }            // 140 ~ 149   // 새로운 메서드 정의
}

// ###########################################################
// 110
// func method1() { print("Class - Table method1") }   // 재정의 안해서 메모리주소 그대로 실행하면됨 즉 메모리주소만 복사
// 130(재정의된 메서드주소)
// func method2() { print("Class - Table method2-2") } // 재정의된 메서드주소 저장한다
// 140(새롭게 정의된 주소)
// func method3() { print("Class - Table method3") }
// ###########################################################




class ParentClass {
    @objc dynamic func method1() { print("Class - Message method1") }
    @objc dynamic func method2() { print("Class - Message method2") }
}

// ###########################################################
// func method1() { print("Class - Message method1") }
// func method2() { print("Class - Message method2") }
// ###########################################################

class ChildClass: ParentClass {
    @objc dynamic override func method2() { print("Class - Message method2-2") }
    @objc dynamic func method3() { print("Class - Message method3") }
}

// ###########################################################
// super class
// func method2() { print("Class - Message method2-2") } // 재정의한 메서드는 다시 주소가짐
// func method3() { print("Class - Message method2") }
// ###########################################################


protocol MyProtocol {
    func method1()    // 요구사항 - Witness Table
    func method2()    // 요구사항 - Witness Table
}


extension MyProtocol {
    // 요구사항의 기본 구현 제공 ==> 프로토콜 withness table만듬
    // 이때 우선순위 고려 !
    func method1() { print("Protocol - Witness Table method1") }
    func method2() { print("Protocol - Witness Table method2") }
    
    // 필수 요구사항은 아님 테이블을 만들지 않는다 ==> Direct Dispatch
    func anotherMothod() {
        print("Protocol Extension - Direct method")
    }
}

class FirstClass: MyProtocol {
    // 다 실제로 구현해버림
    func method1() { print("Class - Virtual Table method1") }
    func method2() { print("Class - Virtual Table method2") }
    func anotherMothod() { print("Class - Virtual Table method3") }
}

/**==============================================================
[Class Virtual Table]
- func method1() { print("Class - Virtual Table method1") }
- func method2() { print("Class - Virtual Table method2") }
- func anotherMothod() { print("Class - Virtual Table method3") }
=================================================================**/

/**==============================================================
[Protocol Witness Table]
- func method1() { print("Class - Virtual Table method1") }   // 요구사항 - 우선순위 반영⭐️
- func method2() { print("Class - Virtual Table method2") }   // 요구사항 - 우선순위 반영⭐️
 =================================================================**/


let first = FirstClass()
first.method1()           // Class - Virtual Table method1
first.method2()           // Class - Virtual Table method2
first.anotherMothod()     // Class - Virtual Table method3


let proto: MyProtocol = FirstClass()
proto.method1()           // Class - Virtual Table method1  (Witness Table)
proto.method2()           // Class - Virtual Table method2  (Witness Table)
proto.anotherMothod()     // Protocol Extension - Direct method

