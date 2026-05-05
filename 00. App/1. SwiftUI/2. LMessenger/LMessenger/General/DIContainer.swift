//
//  DIContainer.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

import Foundation

// MARK: - Dicontainer: service dependency를 담음
// EnciromentObject로 주입될 예정이므로 class + observableObject로 선언

final class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
