//
//  DragglableView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/4/25.
//

//
//  MapView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/4/25.
//

import SwiftUI
import MapKit

extension MKCoordinateRegion {
    static let applePark2 = MKCoordinateRegion(
        center: .init(latitude: 37.3346, longitude: -122.0090),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    )
}

struct DragglableView: View {
    // Bottom Sheet Properties
    @State private var showBottomSheet: Bool = true
    @State private var sheetDetent: PresentationDetent = .height(80)
    @State private var sheetHeight: CGFloat = 0
    @State private var animationDuration: CGFloat = 0
    @State private var toolbarOpacity: CGFloat = 1

    var body: some View {
        Map(initialPosition: .region(.applePark2))
            .sheet(isPresented: $showBottomSheet) {
                GeometryReader { geo in
                    BottomSheetView(sheetDetent: $sheetDetent)
                        .presentationDetents([.height(80), .height(350), .height(700)])
                        .presentationBackgroundInteraction(.enabled)
                        .background(
                            GeometryReader { innerGeo in
                                Color.clear
                                    .onAppear {
                                        sheetHeight = UIScreen.main.bounds.height - innerGeo.frame(in: .global).minY
                                    }
                                    .onChange(of: innerGeo.frame(in: .global).minY) { _, newMinY in
                                        // ✅ 전역 Y 좌표 기반으로 실제 높이 계산
                                        let height = UIScreen.main.bounds.height - newMinY
                                        updateSheetMetrics(oldValue: sheetHeight, newValue: height)
                                    }
                            }
                        )
                        .ignoresSafeArea()
                }
            }
            .overlay(alignment: .bottomTrailing) {
                BottomFloatingToolBar()
            }
    }

    // MARK: - 툴바
    @ViewBuilder
    func BottomFloatingToolBar() -> some View {
        VStack(spacing: 35) {
            Button {
                // 자동차 아이콘 클릭
            } label: {
                Image(systemName: "car.fill")
            }

            Button {
                // 위치 아이콘 클릭
            } label: {
                Image(systemName: "location")
            }
        }
        .font(.title3)
        .foregroundStyle(Color.primary)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .opacity(toolbarOpacity)
        .offset(y: -sheetHeight)
        .animation(.interpolatingSpring(duration: animationDuration, bounce: 0, initialVelocity: 0), value: sheetHeight)
    }

    // MARK: - 시트 높이 변화 계산
    private func updateSheetMetrics(oldValue: CGFloat, newValue: CGFloat) {
        sheetHeight = min(newValue, 650)

        // 투명도 계산
        let progress = max(min((newValue - 650) / 50, 1), 0)
        toolbarOpacity = 1 - progress

        // 애니메이션 속도 계산
        let diff = abs(newValue - oldValue)
        let duration = max(min(diff / 100, 0.3), 0)
        animationDuration = duration
    }
}

struct BottomSheetView2: View {
    @Binding var sheetDetent: PresentationDetent

    var body: some View {
        VStack {
            Text("Hello world!")
                .padding(.top, 20)
        }
    }
}

#Preview {
    DragglableView()
}
