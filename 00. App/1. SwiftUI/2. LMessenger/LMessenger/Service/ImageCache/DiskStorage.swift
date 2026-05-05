//
//  DiskStorage.swift
//  LMessenger
//
//  Created by 김동현 on 2/7/25.
//

import UIKit

protocol DiskStorageType {
    func value(for key: String) throws -> UIImage?          // Disk 값 가져오기
    func store(for key: String, image: UIImage) throws      // Disk 값 저장하기
}

final class DiskStorage: DiskStorageType {
    
    // 파일매니저 정의
    let fileManager: FileManager
    
    // 캐시를 저장할 경로에 해당하는 프로퍼티 정의
    let directoryURL: URL
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageCache")    // cache/ImageCache
        createDirectory()
    }
    
    func createDirectory() {
        // 파일매니저에서 폴더가 존재한다면 리턴, 없으면 생성
        guard !fileManager.fileExists(atPath: directoryURL.path()) else { return }
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
    }
    
    func cacheFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
    // 실제로 URL이 넘어올 예정인데,, 길이가 길거나 슬래시가 섞여 있을 수도 있다...
    // 애플 로그인처럼 nonce 만들어서 SHA 암호화 이용하여 파일 이름 만들자 cacheFileURL()
    func value(for key: String) throws -> UIImage? {
        let fileURL = cacheFileURL(for: key)
        
        // 파일 존재하는지 확인하여 없으면 리턴
        guard fileManager.fileExists(atPath: fileURL.path()) else {
            return nil
        }
        
        // 있으면 url -> data화
        let data = try Data(contentsOf: fileURL)
        
        // data -> image화
        return UIImage(data: data)
    }
    
    // 해당 url을 가진 image가 memoryStorage, diskStorage 둘다 없을 경우 실행된다.
    // 파라미터의 image는 네트워크 통신을 한 결과물이라서 이미지를 cacheDirectory에 저장하자.
    func store(for key: String, image: UIImage) throws {
        let data = image.jpegData(compressionQuality: 0.5)
        let fileURL = cacheFileURL(for: key)
        try data?.write(to: fileURL)
    }
}
