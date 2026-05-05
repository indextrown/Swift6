//
//  MapView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/4/25.
//

/*
 https://www.youtube.com/watch?v=4RWJlgimoc8
 */

import SwiftUI
import MapKit

extension MKCoordinateRegion {
    static let applePark = MKCoordinateRegion(center: .init(latitude: 37.3346, longitude: -122.0090), latitudinalMeters: 1000, longitudinalMeters: 1000)
}

struct MapView: View {
    /// Bottom Sheet Properties
    @State private var showBottomSheet: Bool = true
    @State private var sheetDetent: PresentationDetent = .height(80)
    @State private var sheetHeight: CGFloat = 0
    @State private var animationDuration: CGFloat = 0
    @State private var toolbarOpacity: CGFloat = 1
    
    var body: some View {
        Map(initialPosition: .region(.applePark))
            .sheet(isPresented: $showBottomSheet) {
                BottomSheetView(sheetDetent: $sheetDetent)
                    .presentationDetents([.height(80), .height(350), .height(700)])
                    .presentationBackgroundInteraction(.enabled)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onGeometryChange(for: CGFloat.self) {
                        max(min($0.size.height, 350), 0)
                    } action: { oldValue, newValue in
                        sheetHeight = newValue
                        
                        /// Limiting the offset to 300
                        sheetHeight = min(newValue, 300)
                        
                        /// Calculating Opacity
                        let progress = max(min((newValue - 300) / 50, 1), 0)
                        toolbarOpacity = 1 - progress
                        
                        /// Calculating Animation Duration
                        let diff = abs(newValue - oldValue)
                        let duration = max(min(diff / 100, 0.3), 0)
                        animationDuration = duration
                    }
                    .ignoresSafeArea()
            }
            .overlay(alignment: .bottomTrailing) {
                BottomFloatingToolBar()
            }
    }
    
    @ViewBuilder
    func BottomFloatingToolBar() -> some View {
        VStack(spacing: 35) {
            Button {
                
            } label: {
                Image(systemName: "car.fill")
            }
            Button {
                
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
}

struct BottomSheetView: View {
    @Binding var sheetDetent: PresentationDetent
    var body: some View {
        Text("Hello world!")
    }
}

#Preview {
    MapView()
}
