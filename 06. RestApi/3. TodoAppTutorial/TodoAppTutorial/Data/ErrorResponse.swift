//
//  ErrorResponse.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 4/7/25.
//

import Foundation

struct ErrorResponse: Decodable {
    let data: [Todo]?
    let meta: Meta?
    let message: String?
}
