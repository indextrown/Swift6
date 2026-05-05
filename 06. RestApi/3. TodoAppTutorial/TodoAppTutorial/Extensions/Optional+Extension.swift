//
//  Optional+Extension.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 4/11/25.
//
// https://gist.github.com/TuenTuenna/4f432ce4d9fc28488556ac9943aefd51
// https://www.youtube.com/watch?v=uPk65fHMp4E&list=PLgOlaPUIbynpmuKKPlO_y-9kDdKSEUq-V&index=68

import Foundation

//if case let (user?, pass?) = (user, pass) { }

extension Optional {
    init<T, U>(tuple: (T?, U?)) where Wrapped == (T, U) {
        
//        switch optionalTuple{
//        case let (.some(t?), .some(u?)):
//            self = (t, u)
//        default:
//            self = nil
//        }
         
        switch tuple{
            case (let t?, let u?):
            self = (t, u)
        default:
            self = nil
        }
    }
}

// Optional(( $0 as? String, $1 as? Int))
