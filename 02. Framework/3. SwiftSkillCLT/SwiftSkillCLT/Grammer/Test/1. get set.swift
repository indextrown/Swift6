//
//  get set.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

/*
 get set은 프로퍼티가 읽기(get)와 쓰기(set) 모두 가능한 상태임을 나타낸다.
 즉, 프로퍼티의 값을 가져올 수도 있고(get), 새로운 값으로 설정할 수도 있다(set)
 https://velog.io/@rlawnstn01023/Swift프로퍼티-get-set-didSet-willSet
 */


protocol ReadOnlyProtocol {
    var title: String { get } // 읽기 전용
}

struct ReadOnlyStruct: ReadOnlyProtocol {
    private var _title: String = "Hello, World!" // 내부 저장 프로퍼티
    var title: String { // 읽기 전용 계산 프로퍼티
        return _title
    }
}

protocol ReadWriteProtocol {
    var title: String { get set } // 읽기/쓰기 가능
}

struct ReadWriteStruct: ReadWriteProtocol {
    var title: String // 읽기/쓰기 가능
}

@main
struct Main {
    static func main() {
        let example = ReadOnlyStruct()
        print(example.title) // 출력: Hello, World!
        // example.title = "New Title" // 오류! 쓰기 불가능
        
        // ReadWriteStruct 테스트
                var readWrite = ReadWriteStruct(title: "Hello, ReadWrite!")
                print(readWrite.title) // 출력: Hello, ReadWrite!
                readWrite.title = "New Title" // 쓰기 가능
                print(readWrite.title) // 출력: New Title
    }
}


