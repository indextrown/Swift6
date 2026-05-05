//
//  Path.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/24/24.
//

import Foundation

// MARK: - Model
final class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
