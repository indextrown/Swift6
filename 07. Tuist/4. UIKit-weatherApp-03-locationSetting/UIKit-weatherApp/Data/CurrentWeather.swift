//
//  CurrentWeather.swift
//  UIKit-weatherApp
//
//  Created by Jeff Jeong on 4/30/24.
//

import Foundation

struct CurrentWeather {
    
    static let dictionaryKey : String = "current"
    
    let time: String
    let temperature : String
    let windSpeed : String
    
    init(dictionary: [String : Any]) {
        self.time = dictionary["time"] as? String ?? ""
        
        let temperatureRaw = dictionary["temperature_2m"] as? Double ?? 0.0
        
        self.temperature = "\(temperatureRaw)"
        
        let windSpeedRaw = dictionary["wind_speed_10m"] as? Double ?? 0.0
        
        self.windSpeed = "\(windSpeedRaw)"
        
    }
}
