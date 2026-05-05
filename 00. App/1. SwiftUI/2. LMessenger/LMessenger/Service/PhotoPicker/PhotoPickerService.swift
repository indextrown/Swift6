//
//  PhotoPickerService.swift
//  LMessenger
//
//  Created by 김동현 on 2/6/25.
//

import Foundation
import SwiftUI
import PhotosUI

enum PhotoPickerError: Error {
   case importFailed
}

protocol PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
}

// 이미지 -> 데이터
final class PhotoPickerService: PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        
        // swiftui 이미지가 리턴되지만 우리는 원하는 형태가 있어서 즉 이미지를 업로드 해야하기 때문에 데이터로 변형해야함 -> 모델 생성
        // 값이 없다면 에러를 던지겠다
        guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {
            throw PhotoPickerError.importFailed
        }
        
        return image.data
    }
}

final class StubPhotoPickerService: PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        return Data()
    }
}
