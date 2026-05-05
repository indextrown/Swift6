//
//  Mapkit.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/23/25.
//
// https://apple-document.tistory.com/395
// https://aloe-study.tistory.com/232

import SwiftUI
import MapKit

struct Mapkit: View {
    @StateObject private var locationManager = LocationManager()
    
    @Namespace private var mapScope
   
    //  지도의 현재 중심 좌표
    @State private var position: MapCameraPosition = .automatic
    @State private var hasMovedToCurrentLocation = false
    
    @State private var showSheet: Bool = false

    
    var body: some View {
        VStack {
            Map(position: $position, scope: mapScope) {
                UserAnnotation()
            }
            .alert(isPresented: $locationManager.showPermissionAlert) {
                Alert(
                    title: Text("위치 권한 필요"),
                    message: Text("현재 위치를 확인하려면 설정에서 위치 권한을 허용해주세요."),
                    primaryButton: .default(Text("설정 열기")) {
                        if let url = URL(string: UIApplication.openSettingsURLString),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }

            // ✅ 내 위치로 이동 버튼
            MapUserLocationButton(scope: mapScope)
            
            Button {
                showSheet = true
            } label: {
                Circle()
                    .frame(width: 44, height: 44)
            }
        }
        .ignoresSafeArea()
        .mapScope(mapScope)
        .onReceive(locationManager.$currentLocation.compactMap { $0 }) { coordinate in
            if !hasMovedToCurrentLocation {
                position = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
                hasMovedToCurrentLocation = true
            }
        }
//        .sheet(isPresented: $showSheet) {
//            VStack(spacing: 20) {
//                Text("✅ 테스트 시트입니다")
//                    .font(.title)
//                Button("닫기") {
//                    showSheet = false
//                }
//            }
//            .padding()
//            .presentationDetents([.medium])
//            .frame(maxWidth: .infinity) // 가로는 꽉 채우기
//            .background(.ultraThinMaterial) // 여기서 Blur
//            .opacity(0.25) // 여기서 투명도 조절
//            .overlay(
//                RoundedRectangle(cornerRadius: 20, style: .continuous)
//                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
//            )
//            .frame(width: 200, height: 200)
//            
//            
//        }
    }
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    @Published var showPermissionAlert: Bool = false
    @Published var currentLocation: CLLocationCoordinate2D?
    
    
    override init() {
        super.init()
        
        /// 이 클래스가 CLLocationManager의 대리인이 되어 이벤트를 처리
        manager.delegate = self
        
        /// 위치 정보를 얼마나 정확하게 받아올지
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// 시스템이 위치 권한이 바뀔 때 자동으로 호출해주는 delegate 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("⚠️ 위치 권한 미응답")
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .denied:
            print("❌ 위치 권한 거부됨")
            DispatchQueue.main.async {
                self.showPermissionAlert = true
            }
        case .restricted:
            print("❌ 자녀 보호 등 제한됨")
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ 위치 권한 승인됨 - 위치 추적 시작")
            
            /// 위치 업데이트를 시작,  위치 변경시마다 locationManager(_:didUpdateLocations:)이 자동으로 호출
            /// 사용자의 위치 정보 접근 권한을 요청
            /// 한 번 거부되면 다시 권한 팝업을 띄울 수 없다 이럴때는 설정 앱으로 유도해야한다.
            /// <key>NSLocationWhenInUseUsageDescription</key>
            /// <string>사용자의 위치를 지도에 표시하기 위해 필요합니다.</string>
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
        }
    }

}

#Preview {
    Mapkit()
}
