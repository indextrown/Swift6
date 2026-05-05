//
//  1. Synchronous.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/22/25.
//

import Foundation

// MARK: - 동기
func sync_1() {
    // MARK: - 동기
    let syncUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/codelounge-d7a9d.firebasestorage.app/o/profileImages%2F4RBaUi5FNiVcnudiJRJPAqeDeFl2.jpg?alt=media&token=4729fdca-bd0f-4140-866f-8a7e674dfd89")
    
    if let data = try? Data(contentsOf: syncUrl!) {
        print("동기 Data size: \(data.count)")
    }
    
    print("동기 Done\n")
}

// MARK: - 비동기
func asunc_1() {
    let group = DispatchGroup() // DispatchGroup 생성
    group.enter() // 작업 시작
    
    DispatchQueue.global().async {
        let asyncUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/codelounge-d7a9d.firebasestorage.app/o/profileImages%2F4RBaUi5FNiVcnudiJRJPAqeDeFl2.jpg?alt=media&token=4729fdca-bd0f-4140-866f-8a7e674dfd89")
        
        if let data = try? Data(contentsOf: asyncUrl!) {
            print("비동기 Data size: \(data.count)")
        }
        
        group.leave() // 작업 완료
    }
    
    print("비동기 Done")
    
    // 비동기 작업이 모두 끝날 때까지 대기
    group.wait()
}

// MARK: - 비동기2
func async_2() {
    // 작업 완료 플래그
    var isFinished = false
    
    DispatchQueue.global().async {
        let asyncUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/codelounge-d7a9d.firebasestorage.app/o/profileImages%2F4RBaUi5FNiVcnudiJRJPAqeDeFl2.jpg?alt=media&token=4729fdca-bd0f-4140-866f-8a7e674dfd89")
        
        if let data = try? Data(contentsOf: asyncUrl!) {
            print("비동기 Data size: \(data.count)")
        }
        isFinished = true // 작업 완료 표시
    }
    print("비동기 Done")
    
    
    
    // RunLoop를 활용하여 대기
    let runLoop = RunLoop.current
    // RunLoop가 작업이 완료될 때까지 대기
    while !isFinished && runLoop.run(mode: .default, before: .distantFuture) {}
}

@main
struct Main {
    static func main() {
        
        sync_1()
        async_2()
    }
}

/*
 결과
 동기 Data size:  135418
 동기 Done

 비동기 Done
 비동기 Data size: 135418
 */
