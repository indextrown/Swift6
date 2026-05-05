//
//  HourlyWeather.swift
//  UIKit-weatherApp
//
//  Created by Jeff Jeong on 4/30/24.
//

import Foundation

struct HourlyWeather : CustomStringConvertible {
    
    struct Item {
        let time: String
        let temperature: Double
        let humidity: Double
        let windSpeed: Double
        
        init(time: String, temperature: Double, humidity: Double, windSpeed: Double) {
            self.time = time
            self.temperature = temperature
            self.humidity = humidity
            self.windSpeed = windSpeed
        }
        
        init(_ firstParams:(String, Double), _ secondParams: (Double, Double)){
            self.time = firstParams.0
            self.temperature = firstParams.1
            self.humidity = secondParams.0
            self.windSpeed = secondParams.1
        }
    }
    
    var description: String {
        return "time.count: \(times.count)\ntemperature.count: \(temperatures.count)\nhumidity.count: \(humidities.count)\nwindSpeed.count: \(windSpeeds.count)"
    }
    
    static let dictionaryKey : String = "hourly"
    
    let times: [String]
    let temperatures : [Double]
    let humidities : [Double]
    let windSpeeds: [Double]
    
    init(dictionary: [String : Any]) {
        
        let timeTemp = dictionary["time"]
        
        self.times = dictionary["time"] as? [String] ?? []
        
        self.temperatures = dictionary["temperature_2m"] as? [Double] ?? []
        
        self.humidities = dictionary["relative_humidity_2m"] as? [Double] ?? []
        
        self.windSpeeds = dictionary["wind_speed_10m"] as? [Double] ?? []
    }
    
    func getItems() -> [Item] {
        // 1. 4개의 콜렉션 즉 배열을 묶어어서
        // 2. 반복한다
        // 3. 아이템을 뽑아서
        // 4. Item 배열을 만들자

//        var results : [Item] = []
//
//        for ((time, temperature), (humidity, windSpeed)) in zip(zip(times, temperatures), zip(humidities, windSpeeds)) {
//
//            print("time: \(time)\ntemperature: \(temperature)\nhumidity: \(humidity)\nwindSpeed: \(windSpeed)\n")
//
//            let newItem = Item(time: time, temperature: temperature, humidity: humidity, windSpeed: windSpeed)
//            results.append(newItem)
//        }
        
        let items : [Item] = zip(zip(times, temperatures), zip(humidities, windSpeeds)).map(Item.init)
    
        return items
    }
}
