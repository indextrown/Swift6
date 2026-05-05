//
//  DBError.swift
//  LMessenger
//
//  Created by 김동현 on 6/29/25.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
    case invailedatedType
}
