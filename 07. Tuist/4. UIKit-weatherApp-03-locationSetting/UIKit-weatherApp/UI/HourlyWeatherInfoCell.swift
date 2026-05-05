//
//  HourlyWeatherInfoCell.swift
//  UIKit-weatherApp
//
//  Created by Jeff Jeong on 4/30/24.
//

import Foundation
import UIKit

class HourlyWeatherInfoCell: UITableViewCell {
    
    static let reuserIdentifier : String = "HourlyWeatherInfoCell"
    
    static let cellNib = UINib(nibName: reuserIdentifier, bundle: nil)
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#fileID, #function, #line, "- ")
        
        containerStackView.layer.cornerRadius = 8
        
    }
    
    func configureUI(_ cellData: HourlyWeather.Item){
        self.timeLabel.text = "시간: \(cellData.time)"
        self.temperatureLabel.text = "온도: \(cellData.temperature)"
        self.humidityLabel.text = "습도: \(cellData.humidity)"
        self.windSpeedLabel.text = "바람세기: \(cellData.windSpeed)"
    }
    
    
    // 미니미션
    // 아래 소스코드를 좀 더 편하게 하는 방법 생각해보기
    
    static func register(_ target: UITableView) {
        target.register(HourlyWeatherInfoCell.cellNib, forCellReuseIdentifier: HourlyWeatherInfoCell.reuserIdentifier)
    }
    
}
