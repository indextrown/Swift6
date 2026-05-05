//
//  MusicCell.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import UIKit

class MusicCell: UITableViewCell {

   
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabl: UILabel!
    
    // 속성감시자
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 이미지 url -> 이미지요청(세팅) 메서드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            // MARK: - Data(contentsOf: url)가 동기적이라 dispatchqueue로 비동기처리해야함
            guard let data = try? Data(contentsOf: url) else { return }
            
            // 오래걸리는 작업이 일어나는 동안에 url 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    // 보통 이렇게 쓰면됨
    private func loadImage2() {
        guard let urlString = self.imageUrl else { return }
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            
            guard let safeData = data else { return }
            
            // 오래걸리는 작업이 일어나는 동안에 url 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: safeData)
            }
        }
        
        task.resume()
    }    
}
