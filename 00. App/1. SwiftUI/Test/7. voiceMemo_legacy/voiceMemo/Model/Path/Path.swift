//
//  Path.swift
//  voiceMemo
//

import Foundation

class PathModel: ObservableObject { // 감지를 위해 ObservableObject프로토콜따름
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}

