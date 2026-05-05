//
//  Constant.swift
//  LMessenger
//
//  Created by 김동현 on 1/15/25.
//

import Foundation

//. . Constant.DBKey.Users... 너무 길어서 DBKey.Users로 접근 가능하도록 하자
typealias DBKey = Constant.DBKey

// 1. 여러개의 상수타입이 존재할 수 있으므로 enum
enum Constant {
    
}

// 2.
extension Constant {
    struct DBKey {
        static let Users = "Users"
        static let ChatRooms = "ChatRooms"
        static let Chats = "Chats"
    }
}
