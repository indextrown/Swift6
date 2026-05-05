//
//  DBError.swift
//  LMessenger
//
//  Created by 김동현 on 11/1/24.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
    case invalidatedType
}
