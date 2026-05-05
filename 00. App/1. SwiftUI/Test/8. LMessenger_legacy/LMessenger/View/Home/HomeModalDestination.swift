//
//  HomeModalDestination.swift
//  LMessenger
//
//  Created by 김동현 on 11/1/24.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)
    
    var id: Int {
        hashValue
    }
}
