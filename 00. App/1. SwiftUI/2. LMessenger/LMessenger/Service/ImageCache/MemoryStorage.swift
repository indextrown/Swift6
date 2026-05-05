//
//  MemoryStorage.swift
//  LMessenger
//
//  Created by 김동현 on 2/7/25.
//

import UIKit

protocol MemoryStorageType {
    func value(for key: String) -> UIImage?     // 캐시에서 값을 가져오는 함수
    func store(for key: String, image: UIImage) // 캐시에서 값을 저장하는 함수
}

final class MemoryStorage: MemoryStorageType {
    
    // 캐시 정의(NS 계열이라 두타입 모두 클래스 타입이어야함)
    var cache = NSCache<NSString, UIImage>()
    
    func value(for key: String) -> UIImage? {
        // cache[String -> NSString] = value
        cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
