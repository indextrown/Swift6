//
//  WeatherInfo.swift
//  UIKit-weatherApp
//
//  Created by Jeff Jeong on 4/30/24.
//

import Foundation

struct WeatherInfo {
    
    let currentWeather: CurrentWeather
    let hourlyWeather : HourlyWeather

    init?(dictionary: [String : Any]) {
        
        guard let currentRaw : [String: Any] = dictionary[CurrentWeather.dictionaryKey] as? [String: Any],
              let current: CurrentWeather = CurrentWeather(dictionary: currentRaw) as? CurrentWeather,
              let hourlyRaw : [String: Any] = dictionary[HourlyWeather.dictionaryKey] as? [String: Any],
              let hourly : HourlyWeather = HourlyWeather(dictionary: hourlyRaw) as? HourlyWeather else {
            
            return nil
        }
        self.currentWeather = current
        self.hourlyWeather = hourly
        
        print(#fileID, #function, #line, "- hourlyWeather: \(hourlyWeather)")
    }
}

