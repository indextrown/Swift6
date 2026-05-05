//
//  URLImageView.swift
//  LMessenger
//
//  Created by 김동현 on 2/7/25.
//

import SwiftUI

struct URLImageView: View {
    @EnvironmentObject var container: DIContainer
    
    let urlString: String?
    let placeholderName: String
    
    init(urlString: String?, placeholderName: String? = nil) {
        self.urlString = urlString
        self.placeholderName = placeholderName ?? "placeholder"
    }
    
    var body: some View {
        if let urlString, !urlString.isEmpty {
            URLInnerImageView(viewModel: URLImageViewModel(container: container, urlString: urlString), placeholderName: placeholderName)
                .id(urlString)// innerview url 변경시 내부의 StateObject변경을 위해 명시적인 id 추가
            
        } else {
            // url 없으면 placeholder이미지 보여주자
            Image(placeholderName)
                .resizable()
        }
    }
}

fileprivate struct URLInnerImageView: View {
    
    // 이 뷰는 여러 뷰에서 많이 호출될 예정인데 호출될때마다 viewModel를 세팅하면 번거로울 수 있다
    // 이view를 감싸는 뷰를 만들자
    @StateObject var viewModel: URLImageViewModel
    
    let placeholderName: String
    var placeholderImage: UIImage {
        UIImage(named: placeholderName) ?? UIImage()
    }
    
    var body: some View {
        Image(uiImage: viewModel.loadedImage ?? placeholderImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onAppear {
                if !viewModel.loadingOrSrccess {
                    viewModel.start()
                }
            }
    }
}

#Preview {
    URLImageView(urlString: nil)
}

