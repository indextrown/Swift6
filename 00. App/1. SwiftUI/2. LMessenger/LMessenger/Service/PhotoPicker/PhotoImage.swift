//
//  PhotoImage.swift
//  LMessenger
//
//  Created by 김동현 on 2/6/25.
//

import SwiftUI

struct PhotoImage: Transferable {
    let data: Data
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in // 완료시 data 리턴
            // data ->jpg로 압축 (data를 그대로 사용하면 무거움)
            
            // 이미지화 실패시 에러 발생시키기
            guard let uiImage = UIImage(data: data) else {
                throw PhotoPickerError.importFailed
            }
            
            // 이미지 -> JPEG 형식으로 압축
            guard let data = uiImage.jpegData(compressionQuality: 0.3) else {
                throw PhotoPickerError.importFailed
            }
            
            return PhotoImage(data: data)
        }
    }
}
