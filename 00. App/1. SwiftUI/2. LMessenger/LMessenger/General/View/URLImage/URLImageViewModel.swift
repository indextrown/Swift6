//
//  URLImageViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 2/7/25.
//

import UIKit
import Combine

final class URLImageViewModel: ObservableObject {
    
    private var urlString: String
    private var container: DIContainer
    private var loading: Bool = false
    private var subscription = Set<AnyCancellable>()
    
    @Published var loadedImage: UIImage?
    
    // 현재 이미지 로딩 상태를 나타내는 Bool 값
    var loadingOrSrccess: Bool {
        // loading == true → 이미지를 불러오는 중
        // loadedImage != nil → 이미지가 성공적으로 로드됨
        // true → 이미지가 로딩 중이거나, 이미 성공적으로 로드됨
        // false → 로딩이 끝났지만 loadedImage가 nil(즉, 이미지 로딩 실패)
        return loading || loadedImage != nil
    }
    
    init(container: DIContainer, urlString: String) {
        self.container = container
        self.urlString = urlString
    }
    
    // cached에서 이미지 가져오는 함수
    func start() {
        // url이 비어있으면 리턴
        guard !urlString.isEmpty else { return }
        
        loading = true
        
        container.services.imageCacheService.image(for: urlString)
            .subscribe(on: DispatchQueue.global())  // 긴 작업은 다른 스레드 처리
            .receive(on: DispatchQueue.main)        // 결과를 받을때는 main스레드에서 처리
            .sink { [weak self] image in
                self?.loading = false
                self?.loadedImage = image
            }.store(in: &subscription)
    }
}
