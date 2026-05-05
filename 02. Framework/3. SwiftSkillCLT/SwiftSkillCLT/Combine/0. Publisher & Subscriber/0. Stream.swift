//
//  Stream.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/12/25.
//

import Combine

/*
 스트림(Stream)
 - 데이터의 흐름
 - 시간에 따라 순차적으로 전달되는 값들의 흐름
 - 이 데이터는 비동기적으로 전달가능
 - 전달 과정에서 변환, 필터링, 결합 등이 가능
 
 Publisher
 - 데이터 생성하는 곳
 - 데이터를 만들어내고 이를 스트림 형태로 방추
 
 Subscriber
 - 데이터를 소비하는 곳
 - 스트림에서 데이터를 받아서 처리
 
 스트림의 중요한 특징
 - 시간 기반(스트림은 데이터가 시간에 따라 순차적으로 흘러가는 형태)
 - 비동기 처리(스트림은 데이터가 준비될 때마다 이벤트 발생시키므로 비동기 작업과 어울림)
 - 연속성(데이터가 중단되지 않고 계속 흐를 수도 있고, 완료(completion) 또는 에러(error)가 발생하여 종료될 수 있다
 
 cancellables:
 - Set<AnyCancellable> 타입의 저장소입니다. 여기 저장된 AnyCancellable 객체는 구독이 유지되는 동안 메모리에서 해제되지 않도록 보장합니다.
 
 .store(in: &cancellables):
 - sink 연산자로 반환된 AnyCancellable 객체를 cancellables에 저장합니다.
 - 스트림이 종료되거나 cancellables가 해제되면 자동으로 구독이 취소됩니다.
 
 sink
 - Combine 퍼블리셔(Publisher)에서 방출된 데이터를 소비(consume)하기 위해 사용하는 **구독자(Subscriber)**입니다.
 - 퍼블리셔가 내보내는 데이터를 받아서 처리하는 역할을 합니다.
 - sink를 호출하면 퍼블리셔를 구독합니다.
 - sink 메서드는 두 가지 클로저를 전달받습니다:
 - receiveCompletion: 스트림이 종료될 때(완료 또는 에러 발생 시) 호출되는 클로저.
 - receiveValue: 스트림에서 방출된 값을 처리하는 클로저.
 
 receiveCompletion
 - sink 메서드의 첫번째 클로저입니다.
 - 스트림이 종료(completion) 또는 에러 발생시 호출됩니다.
 - 두가지 상태를 처리합니다
 - finished(스트림 정상 종료)
 - failure(스트림에서 에러가 발생하여 종료)
 
 receiveValue
 - sink메서드의 두번째 클로저입니다.
 - 퍼블리셔가 방출한 값을 받을 때 호출됩니다.
 - 여기서 값을 처리하거나 화면에 표시하는 등의 작업을 수행합니다.
 */

enum MyError: Error {
    case indexWrong
}

@main
struct Main {
    static func main() {
        
        // MARK: - 1. 스트림
        // MARK: - Sink는 AnyCancellable객체를 반환한다. 이 객체는 퍼블리셔와 구독자의 생명주기를 관리하는 데 사용된다.
        // MARK: - 이는 구독 취소 전까지 스트림이 유지된다. AnyCancellable을 저장하지 않으면 구독이 즉시 해제되어 데이터 스트림이 동작하지 않는다.
        // AnyCancellable을 저장할 곳
        var cancellables = Set<AnyCancellable>()
        
        let stream = [1, 2, 3].publisher    // 퍼블리셔
         
        stream
            .sink(
                receiveCompletion: { completion in
                    print("스트림 완료: \(completion)")
            },
                receiveValue: { value in
                    print("받은 값: \(value)")
            })
            // 반환된 AnyCancellable 저장
            .store(in: &cancellables)

        
        // MARK: - 2. receiveCompletion 예제
        let publisher = Fail<Int, MyError>(error: .indexWrong)
        publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                                print("스트림 완료: finished")
                            case .failure(let error):
                                print("스트림 에러 발생: \(error)")
                    }
            },
                receiveValue: { value in
                    print("받은 값: \(value)")
            })
            .store(in: &cancellables)
    }
}

/*
 결과
 받은 값: 1
 받은 값: 2
 받은 값: 3
 스트림 완료: finished
 스트림 에러 발생: indexWrong
 */
