//
//  UserDefaultsManager.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/22/25.
//

import Foundation

// 데이터를 저장하기위한 매니저
// userDefault -> key:value로 이루어짐
class UserDefaultsManager {
    enum Key: String, CaseIterable {
        case refreshToken
        case accessToken
    }
    
    // singleton
    static let shared: UserDefaultsManager = {
        return UserDefaultsManager()
    }()
     
    // 저장된 모든 데이터 지우기
    func clearAll() {
        print("UserDefaultManager - clearAll() called")
        // $0.rawValue): key 이름 가져옴
        Key.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
    
    // 토큰들 저장(사실 영구적인 데이터는 키체인에 저장하는게 좋음 시간상 userdefault에 저장)
    func setTokens(accessToken: String, refreshToken: String) {
        print("UserDefaultManager - setTokens() called")
        UserDefaults.standard.set(accessToken, forKey: Key.accessToken.rawValue)
        UserDefaults.standard.set(refreshToken, forKey: Key.refreshToken.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    // 토큰들 가져오기
    func getTokens() -> TokenData {
        let accessToken = UserDefaults.standard.string(forKey: Key.accessToken.rawValue) ?? ""
        let refreshToken = UserDefaults.standard.string(forKey: Key.refreshToken.rawValue) ?? ""
        // print("가져온 AccessToken - \(accessToken)")
        // print("가져온 RefreshToken - \(refreshToken)")
        return TokenData(accessToken: accessToken, refreshToken: refreshToken)
    }
}


