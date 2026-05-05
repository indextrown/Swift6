//
//  UploadSourceType.swift
//  LMessenger
//
//  Created by 김동현 on 2/6/25.
//

import Foundation

// MARK: - 이미지 업로드 해야할 경우
// 1. 프로필 이미지
// 2. 채팅
enum UploadSourceType {
    case chat(chatRoomId: String)
    case profile(userId: String)
    
    var path: String {
        switch self {
            
        case let .chat(chatRoomId):     // Chats/chatRoomId
            return "\(DBKey.Chats)/\(chatRoomId)"
        case let  .profile(userId):     // Users/UserId
            return "\(DBKey.Users)/\(userId)"
        }
    }
}
 
