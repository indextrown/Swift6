//
//  LocationSettingVC.swift
//  UIKit-weatherApp
//
//  Created by Jeff Jeong on 5/7/24.
//

import Foundation
import UIKit
import MapKit

class LocationSettingVC : UIViewController {
    
    enum SelectMode : Int {
        
        case map
        case myLocation
        
        var info : String {
            switch self {
            case .map:
                return "지도에서 위치설정"
            case .myLocation:
                return "내 위치로 위치설정"
            }
        }
    }
    
    @IBOutlet weak var currentUserLocationLabel: UILabel!
    
    @IBOutlet weak var currentUserLocationLabelContainerView: UIView!
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var pinImageView: UIImageView!
    
    @IBOutlet weak var positionSettingButton: UIButton!
    
    @IBOutlet weak var modeSelectSegmentControl: UISegmentedControl!
    
    var currentSelectedMode : SelectMode = .map
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        
        self.currentUserLocationLabelContainerView.alpha = 0.0
        
        self.currentUserLocationLabelContainerView.layer.cornerRadius = 20
        
        modeSelectSegmentControl.addTarget( self, action: #selector(segmentSelected(sender:)), for: UIControl.Event.valueChanged )
        
        positionSettingButton.addTarget(self, action: #selector(getCenterPosition(sender:)), for: .touchUpInside)
        
        // 위치 요청
        // Request location authorization so the user's current location can be displayed on the map

        
        locationManager.delegate = self
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        switch self.locationManager.authorizationStatus {
        case .denied, .restricted:
            self.locationManager.requestAlwaysAuthorization()
        default:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc private func getCenterPosition(sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        // 버튼 클릭시
        // 지도의 가운데 위치를 가져오자
        
        let center = mapView.centerCoordinate
        
        let latitude = center.latitude
        let longitude = center.longitude
        print(#fileID, #function, #line, "- latitude: \(latitude), longitude: \(longitude)")
        
        let defaults = UserDefaults.standard
        defaults.set(latitude, forKey: "lat")
        defaults.set(longitude, forKey: "lng")
        
        let alert = UIAlertController(title: "위치설정 완료!", message: "경도: \(latitude)\n위도: \(longitude)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func segmentSelected(sender: UISegmentedControl)
    {
        let currentSelectedMode : SelectMode = SelectMode(rawValue: sender.selectedSegmentIndex) ?? .map
        print(#fileID, #function, #line, "selected: \(currentSelectedMode.info)")
        
        self.currentSelectedMode = currentSelectedMode
        
        // 모드가 지도 모드이면
        // 노출
        if currentSelectedMode == .map {
            
            self.currentUserLocationLabelContainerView.alpha = 0.0
            
            UIView.animate(withDuration: 0.7, animations: {
                self.pinImageView.alpha = 1.0
                self.positionSettingButton.alpha = 1.0
            })
            
        } else {
            // 모드가 내 위치로 설정이면
            // 비노출
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: .curveEaseOut,
                           animations: {
                self.pinImageView.alpha = 0.0
                self.positionSettingButton.alpha = 0.0
                self.currentUserLocationLabelContainerView.alpha = 1.0
            },completion: { _ in
                print(#fileID, #function, #line, "- 애니메이션 끝")
            })
        }
    }
    
    
}

extension LocationSettingVC: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        print(#fileID, #function, #line, "- status: \(status)")
        switch status {
        case .denied, .restricted:
            self.locationManager.requestAlwaysAuthorization()
        default:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        currentUserLocationLabel.text = "현재 사용자 위치:\n경도: \(locValue.latitude)\n위도: \(locValue.longitude)"
        
        if currentSelectedMode == .myLocation {
            let defaults = UserDefaults.standard
            defaults.set(locValue.latitude, forKey: "lat")
            defaults.set(locValue.longitude, forKey: "lng")
        }
        
    }
}
