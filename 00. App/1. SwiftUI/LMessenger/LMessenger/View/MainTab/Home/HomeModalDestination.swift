//
//  HomeModalDestination.swift
//  LMessenger
//
//  Created by 김동현 on 7/8/25.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)
    var id: Int {hashValue}
}
