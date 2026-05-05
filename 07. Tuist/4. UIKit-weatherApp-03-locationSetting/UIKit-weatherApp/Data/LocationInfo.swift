//
//  LocationInfo.swift
//  UIKit-weatherApp
//
//  Created by Jeff Jeong on 4/30/24.
//

import Foundation

struct LocationInfo {
    let name: String
    let latitude: Double
    let longitude: Double
    
    var infoLabelString: String {
        return "현재 지역: \(self.name) 위치: \(latitude), \(longitude)"
    }
    
    static func getKoreanLocationInfoList() -> [LocationInfo] {
        return [
            LocationInfo(name: "강원강릉시", latitude: 37.74913611, longitude: 128.8784972),
            LocationInfo(name: "강원고성군", latitude: 38.37796111, longitude: 128.4701639),
            LocationInfo(name: "강원동해시", latitude: 37.52193056, longitude: 129.1166333),
            LocationInfo(name: "강원삼척시", latitude: 37.44708611, longitude: 129.1674889),
            LocationInfo(name: "강원속초시", latitude: 38.204275, longitude: 128.5941667),
        ]
    }
}

extension LocationInfo: Equatable {
    static func == (lhs: LocationInfo, rhs: LocationInfo) -> Bool {
        return lhs.name == rhs.name
    }
}
