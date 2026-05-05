//
//  String?+.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/18/25.
//

import Foundation

extension String? {
    func getNumber() -> Int {
        return Int(self ?? "0") ?? 0
    }
}

extension String {
    func getNumber() -> Int {
        return Int(self) ?? 0
    }
}
