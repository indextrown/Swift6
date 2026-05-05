//
//  GeolocationService.swift
//  RxExample
//
//  Created by Carlos García on 19/01/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

class GeolocationService {
    // MARK: - 메모리를 하나만 쓰기 위해 static let으로 자기자신을 가져오는것
    static let instance = GeolocationService()
    
    
    // MARK: - Driver
    /*
     실패하지 않는다
     메인스레드에서 실행된다
     구독의 형태를 share하는게 기본적으로 깔려있다
     옵저버블에서 추가된게 driver이다
     */
    private (set) var authorized: Driver<Bool>
    private (set) var location: Driver<CLLocationCoordinate2D>
    
    private let locationManager = CLLocationManager()
    
    private init() {
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // MARK: - deferred: 구독할때마다 이벤트를 받음
        authorized = Observable.deferred { [weak locationManager] in
                let status = CLLocationManager.authorizationStatus()
            
            // MARK: - 만약 이게 없다면 현재 상태를 가져와라
                guard let locationManager = locationManager else {
                    return Observable.just(status)
                }
            
            // MARK: - 이게 있다면 즉 한번이라도 해당 위치 서비스를 사용했다면
                return locationManager
            // MARK: - 프록시 = 대리자
            /// RxCocoa의 delegate를 어떻게 rx에서 풀어나가지?
                    // 변경이 일어나지 않으면 실행 안됨?
                    .rx.didChangeAuthorizationStatus
                    // 변경이 일어나지 않았을 경우를 대비해서 현재 상태 붙이기
                    .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map {
                switch $0 {
                case .authorizedAlways:
                    return true
                case .authorizedWhenInUse:
                    return true    
                default:
                    return false
                }
            }
        
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}
