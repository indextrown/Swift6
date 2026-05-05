//
//  3. Swift6에서의 @retroactive 키워드.swift
//  Swift5
//
//  Created by 김동현 on 2/5/25.
//


/*
 MARK: - Swift6에서의 @retroactive 키워드의 의미(소급적용 시키겠다는 의미)
 프로토콜의 경우, 특히나 외부 타입들이 나중에 준수하게되는 경우도 생길 수 있음을 대비해서
 에러가 아닌 경고로 미리 보여주는 것
 */


// MARK: - 애플이 추후에 Foundation에서 기본적으로 기본 타입들이 Error 프로토콜을 채택하게 된다면 프로토콜을 두번 채택을 하기 때문에 컴파일 에러 발생
// @retroactive: String이 나중에 소급적용이 될 수도 있는 가능성을 가진 코드임을 경고
extension String: @retroactive Error {}



