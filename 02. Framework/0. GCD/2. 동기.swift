//
//  1. 동기.swift
//  Swift5
//
//  Created by 김동현 on 2/3/25.
//

import Foundation

let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/codelounge-d7a9d.firebasestorage.app/o/profileImages%2FO5ughn6bR1Nidh1uaCnHZ52MZfQ2.jpg?alt=media&token=041241e3-8aa8-43c0-8c1c-217acaca6e44")!


@main
struct Main {
    static func main() {
        
        if let data = try? Data(contentsOf: url) {
            print("Data size: \(data.count)")
        }
        
        print("Done!")
    }
}
