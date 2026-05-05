//
//  Coordinator.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/20/25.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
