//
//  MusicCollectionViewCell.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mainImageViewCell: UIImageView!
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            // 오래걸리는 작업이 일어나는 동안에 url 바뀔 가능성 제거
            guard self.imageUrl! == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageViewCell.image = UIImage(data: data)
            }
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해 실행
        self.mainImageViewCell.image = nil
    }
}
