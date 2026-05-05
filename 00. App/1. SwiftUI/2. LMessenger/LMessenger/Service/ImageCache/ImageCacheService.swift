//
//  ImageCacheService.swift
//  LMessenger
//
//  Created by 김동현 on 2/7/25.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

// expireddate, 용량은 추후에 해보자
final class ImageCacheService: ImageCacheServiceType {
    
    let memoryStorage: MemoryStorageType
    let diskStorage: DiskStorageType
    
    init(memoryStorage: MemoryStorageType, diskStorage: DiskStorageType) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        /*
         1. memoryStorage 확인
         2. diskStorage 확인
         3. urlSession을 통해 이미지를 가져와서 memoryStorage, diskStorage에 각각 저장
         이 작업들을 combine으로 stream을 이어서 작업 해보자
         */
        
        // 1. 이미지 캐시 확인
        imageWithMemoryCache(for: key)
            .flatMap { image -> AnyPublisher<UIImage?, Never> in
                // 2. 이미지가 있으면 본낸다
                if let image {
                    return Just(image).eraseToAnyPublisher()
                } else {
                    // 2. 이미지가 없으면 diskStorage에서 확인한다
                    return self.imagwWithDiskCache(for: key)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Publisher
    // memoryStorage 확인 작업
    func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            // memoryStorage에서 key로 value 가져오기
            let image = self?.memoryStorage.value(for: key)
            promise(.success(image))
        }.eraseToAnyPublisher()
    }
    
    // diskStorage 확인 작업
    func imagwWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> { [weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
        }
        .flatMap { image -> AnyPublisher<UIImage?, Never> in
            
            if let image {
                return Just(image)
                    .handleEvents(receiveOutput: { [weak self] image in
                        guard let image else { return  }
                        self?.store(for: key, image: image, toDisk: false)
                    })
                    .eraseToAnyPublisher()
            } else {
                // 네트워크 통신
                return self.remoteImage(for: key)
            }
        }
        .eraseToAnyPublisher()
    }
    
    // 네트워크 통신
    func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map { data, _ in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image else { return }
                self?.store(for: urlString, image: image, toDisk: true)
            })
            .eraseToAnyPublisher()
    }
    
    // 만약 urlSession으로 정보를 받아왔다면, storage에 저장해야함
    // 만약 DiskCache에만 있는 경우 MemoryCache에도 저장해야함
    func store(for key: String, image: UIImage, toDisk: Bool) {
        // 이 함수가 호출된다면 memoryStorage에 무조건 넣는다
        memoryStorage.store(for: key, image: image)
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}

final class StubImageCacheService: ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
