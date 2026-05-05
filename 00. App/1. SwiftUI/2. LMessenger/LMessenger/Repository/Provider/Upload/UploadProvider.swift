//
//  UploadProvider.swift
//  LMessenger
//
//  Created by 김동현 on 2/6/25.
//

import Foundation
import FirebaseStorage

protocol UploadProviderType {
    func upload(path: String, data: Data, fileName: String) async throws -> URL
}

final class UploadProvider: UploadProviderType {
    
    // firebase 업로드/다운로드/삭제 작업을 위해 storage reference를 만들어야 한다
    // reference는 클라우드의 파일을 가리키는 포인터
    let storageRef = Storage.storage().reference()
    
    // 업로드 된 URL을 리턴
    func upload(path: String, data: Data, fileName: String) async throws -> URL {
        let ref = storageRef.child(path).child(fileName)
        
        // storage는 async/await지원하여 간단하다
        let _ = try await ref.putDataAsync(data)
        
        // 업로드 되면 downloadurl을 통해 업로드 된 url을 받자
        let url = try await ref.downloadURL()
        
        return url
    }
}
