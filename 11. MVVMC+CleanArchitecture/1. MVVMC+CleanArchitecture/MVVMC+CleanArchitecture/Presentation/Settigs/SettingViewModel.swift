//
//  SettingViewModel.swift
//  MVVMC+CleanArchitecture
//
//  Created by 김동현 on 3/27/25.
//

import UIKit

final class SettingsViewModel {
    private weak var coordinator: AppCoordinator?

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func didTapBack() {
        coordinator?.pop()
    }
}

