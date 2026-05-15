//
//  EventBus.swift
//  Diary
//
//  Created by 김동현 on 5/8/26.
//

import Foundation
import RxSwift

class EventBus {
    static let shared = EventBus()
    private init() {}
    
    // subject: 구독, 값전달 2가지 기능
    private let subject = PublishSubject<DiaryEvent>()
    
    func asObservable() -> Observable<DiaryEvent> {
        return subject.asObservable()
    }
    
    func publish(event: DiaryEvent) {
        subject.onNext(event)
    }
}

enum DiaryEvent {
    case refreshList
    case refreshDetail
}




