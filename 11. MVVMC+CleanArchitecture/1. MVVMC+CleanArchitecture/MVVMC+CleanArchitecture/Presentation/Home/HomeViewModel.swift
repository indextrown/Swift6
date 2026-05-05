//
//  HomeViewModel.swift
//  MVVMC+CleanArchitecture
//
//  Created by 김동현 on 3/27/25.
//

import UIKit

final class HomeViewModel {
    private weak var coordinator: AppCoordinator?

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    
    func didTapDetail() {
        coordinator?.showDetail()
    }

    func didTapSettings() {
        coordinator?.showSettings()
    }
}

