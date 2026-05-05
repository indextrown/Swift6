//
//  3. 비동기 콜백.swift
//  Swift5
//
//  Created by 김동현 on 2/3/25.
//

import Foundation

let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/codelounge-d7a9d.firebasestorage.app/o/profileImages%2FO5ughn6bR1Nidh1uaCnHZ52MZfQ2.jpg?alt=media&token=041241e3-8aa8-43c0-8c1c-217acaca6e44")!


@main
struct Main {
    static func main() {
        
        let group = DispatchGroup()
        group.enter() // 그룹에 작업 추가
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            print("Success")
        }
        
        task.resume()
        print("Done?")
        
        group.wait()
    }
}
