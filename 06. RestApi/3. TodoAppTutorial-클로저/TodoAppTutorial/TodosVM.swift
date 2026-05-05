//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/25/25.
//

import Combine
import Foundation
import RxCocoa
import RxRelay
import RxSwift
import RxCombine

// API 호출부분에서는 rx, combine다할거지만 viewModel는 combine로 처리하자.. swiftui에서도 사용하기위해
// MARK: - viewModel은 단순 api 호출, serviceLayer에서 연쇄적인 API로직 구현
final class TodosVM: ObservableObject {  // ObservableObject -> 변경에 대한 감지

    // MARK: - 구둘다 구독을 저장해서 해제 시점에 자동으로 정리해주는 역할(메모리 누수 방지, 찌꺼기 처리)
    // MARK: - RxSwift: Disposable 보관용
    // 뷰 또는 뷰모델 해제 시 자동으로 구독이 취소되도록 관리
    // DisposeBag은 내부적으로 변경되지 않기 때문에 let으로 선언가능
    private let disposeBag = DisposeBag()

    // MARK: - Combine: 구독 관리용
    // .store(in: &subscriptions) 구문에서 참조를 수정해야 하므로, var가 필요
    // let이면 &subscriptions에서 Cannot pass immutable value as inout argument 에러 발생
    private var subscriptions = Set<AnyCancellable>()

    init() {
        // fetchTodosWithObservable를Combine으로()
    }

    /// API 에러처리
    /// - Parameter err: API에러
    fileprivate func handleError(_ err: Error) {
        if err is TodosAPI.ApiError {
            let apiError = err as! TodosAPI.ApiError

            print("handleError: err: \(apiError.info)")

            switch apiError {
            case .noContentError:
                print("컨텐츠 없음")
            case .unAuthorized:
                print("인증안함")
            default:
                return
            //print("default")
            }
        }
    }
}

// MARK: - 클로저 기반
extension TodosVM {
    /*
     TodosAPI.fetchSelectedTodos(selectedTodoIds: [7183, 7179]) { result in
     switch result {
     case .success(let data):
     print("TodosVM - fetchSelectedTodos: \(data)")
     case .failure(let failure):
     print("TodosVM - fetchSelectedTodos: \(failure)")
     }
     }
     */

    /*
     TodosAPI.deleteSelectedTodos(selectedTodoIds: [7191, 7192, 7184]) { [weak self] deletedTodos in
     //guard let self = self else { return }
     print("TodosVM - deleteSelectedTodos: \(deletedTodos)")
     }
     */
    /*
     TodosAPI.addATodoAndFetchTodos(title: "Coding Test0") { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let todoListResponse):
     // print("TodosVM - addATodoAndFetchTodos: \(todoListResponse.data!)")
     print("TodosVM - addATodoAndFetchTodos: \(todoListResponse.data!.count)")
     case .failure(let failure):
     print("TodosVM addATodoAndFetchTodos - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */

    /*
     TodosAPI.deleteATodo(id: 7180) { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let aTodosResponse):
     print("TodosVM - deleteATodo: \(aTodosResponse)")
     case .failure(let failure):
     print("TodosVM - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */

    /*
     TodosAPI.editATodoPut(id: 7188, title: "Put 수정", isDone: true) { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let aTodosResponse):
     print("TodosVM - editTodoPut: \(aTodosResponse)")
     case .failure(let failure):
     print("TodosVM - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */
    /*
     TodosAPI.editTodoJson(id: 7188, title: "Coding Test 수정", isDone: true) { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let aTodosResponse):
     print("TodosVM - editTodoJson: \(aTodosResponse)")
     case .failure(let failure):
     print("TodosVM - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */

    /*
     TodosAPI.addATodoJson(title: "Coding Test2", isDone: true) { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let aTodosResponse):
     print("TodosVM - atodosResponse: \(aTodosResponse)")
     case .failure(let failure):
     print("TodosVM - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */
    /*
     TodosAPI.addATodo(title: "Coding Test") { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let aTodosResponse):
     print("TodosVM - todosResponse: \(aTodosResponse)")
     case .failure(let failure):
     print("TodosVM - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */

    /*
     TodosAPI.searchTodos(searchTerm: "빡코딩") { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let todosResponse):
     print("TodosVM - todosResponse: \(todosResponse)")
     case .failure(let failure):
     print("TodosVM - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */
    /*
     TodosAPI.fetchATodos(id: 7182) { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let aTodoResponse):
     print("TodosVM - todoResponse: \(aTodoResponse)")
     case .failure(let failure):
     print("TodosVM - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */

    /*
     TodosAPI.fetchTodos { [weak self] result in
     guard let self = self else { return }

     switch result {
     case .success(let todosResponse):
     print("TodosVM - todosResponse: \(todosResponse)")
     case .failure(let failure):
     print("TodosVM - failure: \(failure)")
     self.handleError(failure)
     }
     }
     */
}

// MARK: - rx
extension TodosVM {
    /*
     RxSwift URL 요청 로깅 비활성화
     #if DEBUG
     URLSession.shared.configuration.httpAdditionalHeaders = ["Accept": "application/json"]
     URLSession.shared.configuration.timeoutIntervalForRequest = 30
     URLSession.shared.configuration.timeoutIntervalForResource = 300
     #endif


     print(#fileID, #function, #line, "- ")
     // addATodoAndFetchTodosWithObservable_2()
     fetchSelectedTodosWithObservable()
     */
    func fetchTodosWithObservableResult() {
        TodosAPI.fetchTodosWithObservableResult()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    print(
                        "TodosVM - fetchTodosWithObservableResult : response: \(response)"
                    )
                case .failure(let failure):
                    self.handleError(failure)
                }
            }
            // 구독한거의 찌꺼기를 담는다
            .disposed(by: disposeBag)
    }

    func fetchTodosWithObservable() {
        TodosAPI.fetchTodosWithObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { (response: BaseListResponse<Todo>) in
                    print(
                        "TodosVM - fetchTodosWithObservable : response: \(response)"
                    )
                },
                onError: { [weak self] error in
                    self?.handleError(error)
                }
            ).disposed(by: disposeBag)
    }

    func fetchTodosWithObservable2() {
        TodosAPI.fetchTodosWithObservable()
            .observe(on: MainScheduler.instance)
            .compactMap { $0.data }  // Optional([Todo]) -> [Todo]
            // MARK: - [선택사항] 개발중 에러를 onError로 받지 않고 무조건 받을건데 중간에 에러가 나면 빈 배열을 받거나 특정한 상태를 받으려면 catch를 넣고 그게 아니라면 onError에서 핸들링 하면 된다
            .catch({ err in
                // 에러가 들어온다면 빈 리스트를 보낸다
                print("TodosVM - catch : err: \(err)")
                return Observable.just([])
            })
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { (response: [Todo]) in
                    print(
                        "TodosVM - fetchTodosWithObservable : response: \(response)"
                    )
                },
                onError: { [weak self] error in
                    self?.handleError(error)
                }
            ).disposed(by: disposeBag)
    }

    func addATodoAndFetchTodosWithObservable_1() {
        TodosAPI.addATodoAndFetchTodosWithObservable_1(title: "RX Test")
            .observe(on: MainScheduler.instance)
            .compactMap { $0.data }  // Optional([Todo]) -> [Todo]
            // MARK: - [선택사항] 개발중 에러를 onError로 받지 않고 무조건 받을건데 중간에 에러가 나면 빈 배열을 받거나 특정한 상태를 받으려면 catch를 넣고 그게 아니라면 onError에서 핸들링 하면 된다
            .catch({ err in
                // 에러가 들어온다면 빈 리스트를 보낸다
                print("TodosVM - catch : err: \(err)")
                return Observable.just([])
            })
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { (response: [Todo]) in
                    print(
                        "TodosVM - addATodoAndFetchTodosWithObservable : response: \(response)"
                    )
                },
                onError: { [weak self] error in
                    self?.handleError(error)
                }
            ).disposed(by: disposeBag)

    }

    func addATodoAndFetchTodosWithObservable_2() {
        TodosAPI.addATodoAndFetchTodosWithObservable_2(title: "RX Test")
            .observe(on: MainScheduler.instance)
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { (response: [Todo]) in
                    print(
                        "TodosVM - addATodoAndFetchTodosWithObservable : response: \(response)"
                    )
                },
                onError: { [weak self] error in
                    self?.handleError(error)
                }
            ).disposed(by: disposeBag)

    }

    func deleteSelectedTodosWithObservable() {
        TodosAPI.deleteSelectedTodosWithObservable(selectedTodoIds: [
            7194, 7201,
        ])
        .subscribe(
            onNext: { delectedTodos in
                print(
                    "TodosVM - deleteSelectedTodosWithObservable : delectedTodos: \(delectedTodos)"
                )
            },
            onError: { err in
                print(
                    "TodosVM - deleteSelectedTodosWithObservable : err: \(err)")
            }
        )
        .disposed(by: disposeBag)
    }

    func deleteSelectedTodosWithObservableMerge() {
        TodosAPI.deleteSelectedTodosWithObservableMerge(selectedTodoIds: [
            7200, 7178,
        ])
        .subscribe(
            onNext: { delectedTodos in
                print(
                    "TodosVM - deleteSelectedTodosWithObservableMerge : delectedTodos: \(delectedTodos)"
                )
            },
            onError: { err in
                print(
                    "TodosVM - deleteSelectedTodosWithObservableMerge : err: \(err)"
                )
            }
        )
        .disposed(by: disposeBag)
    }

    func fetchSelectedTodosWithObservable() {
        TodosAPI.fetchSelectedTodosWithObservable(selectedTodoIds: [
            7174, 7175, 7176,
        ])
        .subscribe(
            onNext: { fetchedTodos in
                print(
                    "TodosVM - fetchSelectedTodosWithObservable : fetchedTodos: \(fetchedTodos)"
                )
            },
            onError: { err in
                print(
                    "TodosVM - fetchSelectedTodosWithObservable : err: \(err)")
            }
        )
        .disposed(by: disposeBag)
    }
}

// MARK: - Combine 구독
extension TodosVM {
    func fetchTodosWithPublisherResult() {
        TodosAPI.fetchTodosWithPublisherResult()
            // Combine에서 이벤트 처리 방식
            // 에러가 발생하지 않는 Publisher이므로 sink만 사용
            .sink { result in
                switch result {
                case .failure(let failure):
                    self.handleError(failure)
                case .success(let baseListTodoResponse):
                    print(
                        "TodosVM - fetchTodosWithPublisherResult: baseListTodoResponse \(baseListTodoResponse)"
                    )
                }
                // 메모리 관리를 위해 subscriptions에 저장 (구독 해제용)
            }.store(in: &subscriptions)
    }

    func fetchTodosWithPublisher() {
        TodosAPI.fetchTodosWithPublisher()
            // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
            // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
            // 따라서 [weak self]로 캡처하여 메모리 누수 방지
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print("TodosVM - fetchTodosWithPublisher: response \(response)")
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func fetchTodosWithPublisher_디코딩먼저하는방식() {
        TodosAPI.fetchTodosWithPublisher_디코딩먼저하는방식()
            // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
            // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
            // 따라서 [weak self]로 캡처하여 메모리 누수 방지
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print(
                    "TodosVM - fetchTodosWithPublisher_디코딩먼저하는방식: response \(response)"
                )
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func fetchATodoWithPublisher() {
        TodosAPI.fetchATodoWithPublisher(id: 7174)
            // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
            // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
            // 따라서 [weak self]로 캡처하여 메모리 누수 방지
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print("TodosVM - fetchATodoWithPublisher: response \(response)")
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func searchTodosWithPublisher() {
        TodosAPI.searchTodosWithPublisher(searchTerm: "할 일")
            // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
            // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
            // 따라서 [weak self]로 캡처하여 메모리 누수 방지
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print(
                    "TodosVM - searchTodosWithPublisher: response \(response)")
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func addATodoWithPublisher() {
        TodosAPI.addATodoWithPublisher(title: "Combine 할 일 추가", isDone: false)
            // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
            // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
            // 따라서 [weak self]로 캡처하여 메모리 누수 방지
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print("TodosVM - addATodoWithPublisher: response \(response)")
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func addATodoJsonWithPublisher() {
        TodosAPI.addATodoJsonWithPublisher(
            title: "Combine json 할 일 추가", isDone: false
        )
        // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
        // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
        // 따라서 [weak self]로 캡처하여 메모리 누수 방지
        .sink { [weak self] completion in
            // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
            guard let self = self else { return }

            switch completion {
            case .failure(let failure):
                // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                self.handleError(failure)
            case .finished:
                print("TodosVM - finished")
            }
        } receiveValue: { response in
            print("TodosVM - addATodoJsonWithPublisher: response \(response)")
        }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func editATodoJsonWithPublisher() {
        TodosAPI.editATodoJsonWithPublisher(
            id: 7203, title: "Combine json 할 일 수정", isDone: false
        )
        // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
        // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
        // 따라서 [weak self]로 캡처하여 메모리 누수 방지
        .sink { [weak self] completion in
            // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
            guard let self = self else { return }

            switch completion {
            case .failure(let failure):
                // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                self.handleError(failure)
            case .finished:
                print("TodosVM - finished")
            }
        } receiveValue: { response in
            print("TodosVM - editATodoJsonWithPublisher: response \(response)")
        }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func editATodoPutWithPublisher() {
        TodosAPI.editATodoPutWithPublisher(
            id: 7203, title: "Combine json 할 일 수정2", isDone: false
        )
        // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
        // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
        // 따라서 [weak self]로 캡처하여 메모리 누수 방지
        .sink { [weak self] completion in
            // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
            guard let self = self else { return }

            switch completion {
            case .failure(let failure):
                // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                self.handleError(failure)
            case .finished:
                print("TodosVM - finished")
            }
        } receiveValue: { response in
            print("TodosVM - editATodoPutWithPublisher: response \(response)")
        }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func deleteATodoWithPublisher() {
        TodosAPI.deleteATodoWithPublisher(id: 7202)
            // MARK: - Combine의 sink는 구독이 유지되는 동안 클로저도 살아있음
            // self보다 오래 살아남을 수 있기 때문에 순환 참조(Retain Cycle) 가능성 존재
            // 따라서 [weak self]로 캡처하여 메모리 누수 방지
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print(
                    "TodosVM - deleteATodoWithPublisher: response \(response)")
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func addATodoAndFetchTodosWithPublisher_1() {
        TodosAPI.addATodoAndFetchTodosWithPublisher_1(title: "Combine 연쇄처리 - 1")
            // 에러를 받기 때문에 rceiveCompletion 처리
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print(
                    "TodosVM - addATodoAndFetchTodosWithPublisher_1: response \(response)"
                )
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func addATodoAndFetchTodosWithPublisher_2() {
        // api 호출하고나서 추가되는 값이 리턴
        TodosAPI.addATodoAndFetchTodosWithPublisher_2(title: "Combine 연쇄처리")
            // 에러를 받기 때문에 rceiveCompletion 처리
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print(
                    "TodosVM - addATodoAndFetchTodosWithPublisher_2: response \(response)"
                )
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func addATodoAndFetchTodosWithPublisher_3() {
        TodosAPI.addATodoAndFetchTodosWithPublisher_3(title: "Combine 연쇄처리")
            // 에러를 받기 때문에 rceiveCompletion 처리
            .sink { [weak self] completion in
                // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
                guard let self = self else { return }

                switch completion {
                case .failure(let failure):
                    // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                    self.handleError(failure)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print(
                    "TodosVM - addATodoAndFetchTodosWithPublisher_3: response \(response)"
                )
            }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func deleteSelectedTodosWithPublisherMerge_1() {
        // 배열 즉 2개가 묶여있어서 2개가 응답으로 들어온다
        // MARK: - 7210, 7209는 없는거, 7174은 있다면 에러는 2번이 아닌 한번만 호출된다..-> 중간에 에러가 타게되면 나머지 스트림이 끊기기 떄문이다
        // MARK: - 모든 에러에 대해 핸들링을 하려면? 에러를 꺼내는 것이 아니라 형태를 바꿔야 한다
        TodosAPI.deleteSelectedTodosWithPublisherMerge_1(selectedTodoIds: [
            7210, 7209, 7174,
        ])
        // 에러를 받기 때문에 rceiveCompletion 처리
        .sink { [weak self] completion in
            // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
            guard let self = self else { return }

            switch completion {
            case .failure(let failure):
                // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                self.handleError(failure)
            case .finished:
                print("TodosVM - finished")
            }
        } receiveValue: { response in
            print(
                "TodosVM - deleteSelectedTodosWithPublisherMerge_1: response \(response)"
            )
        }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func deleteSelectedTodosWithPublisherMerge_2() {
        // 배열 즉 2개가 묶여있어서 2개가 응답으로 들어온다
        // MARK: - 7210, 7209는 없는거, 7174은 있다면 에러는 2번이 아닌 한번만 호출된다..-> 중간에 에러가 타게되면 나머지 스트림이 끊기기 떄문이다
        // MARK: - 모든 에러에 대해 핸들링을 하려면? 에러를 꺼내는 것이 아니라 형태를 바꿔야 한다
        TodosAPI.deleteSelectedTodosWithPublisherMerge_2(selectedTodoIds: [
            7175, 7176, 7177,
        ])
        // 에러를 받기 때문에 rceiveCompletion 처리
        .sink { [weak self] completion in
            // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
            guard let self = self else { return }

            switch completion {
            case .failure(let failure):
                // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                self.handleError(failure)
            case .finished:
                print("TodosVM - finished")
            }
        } receiveValue: { response in
            print(
                "TodosVM - deleteSelectedTodosWithPublisherMerge_2: response \(response)"
            )
        }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func deleteSelectedTodosWithPublisherZip() {
        TodosAPI.deleteSelectedTodosWithPublisherZip(selectedTodoIds: [
            7173, 6958, 6437,
        ])
        // 에러를 받기 때문에 rceiveCompletion 처리
        .sink { [weak self] completion in
            // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
            guard let self = self else { return }

            switch completion {
            case .failure(let failure):
                // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                self.handleError(failure)
            case .finished:
                print("TodosVM - finished")
            }
        } receiveValue: { response in
            print(
                "TodosVM - deleteSelectedTodosWithPublisherMerge_2: response \(response)"
            )
        }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func fetchSelectedTodosWithPublisher() {
        TodosAPI.fetchSelectedTodosWithPublisher(selectedTodoIds: [
            6693, 6435, 6179,
        ])
        // 에러를 받기 때문에 rceiveCompletion 처리
        .sink { [weak self] completion in
            // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
            guard let self = self else { return }

            switch completion {
            case .failure(let failure):
                // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                self.handleError(failure)
            case .finished:
                print("TodosVM - finished")
            }
        } receiveValue: { response in
            print(
                "TodosVM - fetchSelectedTodosWithPublisher: response \(response)"
            )
        }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }

    func fetchSelectedTodosWithPublisherMerge() {
        TodosAPI.fetchSelectedTodosWithPublisherMerge(selectedTodoIds: [
            6693, 6435, 6179,
        ])
        // 에러를 받기 때문에 rceiveCompletion 처리
        .sink { [weak self] completion in
            // weak self로 캡처했으므로 guard로 안전하게 self를 래핑하여 강한 참조 막아주기
            guard let self = self else { return }

            switch completion {
            case .failure(let failure):
                // self를 클로저 내부에서 사용 → 강한 참조 발생 가능
                self.handleError(failure)
            case .finished:
                print("TodosVM - finished")
            }
        } receiveValue: { response in
            print(
                "TodosVM - fetchSelectedTodosWithPublisherMerge: response \(response)"
            )
        }.store(in: &subscriptions)  // 구독을 저장하여 메모리 관리 (자동 구독 해제)
    }
}

// MARK: - Async
extension TodosVM {
    func fetchTodosWithAsyncResult() {
        Task {
            let response = await TodosAPI.fetchTodosWithAsyncResult()
            print("fetchTodosWithAsyncResult response: \(response)")
        }
    }

    func fetchTodosWithAsync() {
        /*
         MARK: 에러를 처리하지 않는다면 try?
         Task {
         let response = try? await TodosAPI.fetchTodosWithAsync()
         print("fetchTodosWithAsync response: \(response)")
         }
         */

        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response = try await TodosAPI.fetchTodosWithAsync()
                print("fetchTodosWithAsync response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func fetchATodoWithAsync() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response = try await TodosAPI.fetchATodoWithAsync(id: 6693)
                print("fetchATodoWithAsync response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func searchTodosWithAsync() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response = try await TodosAPI.searchTodosWithAsync(
                    searchTerm: "할 일")
                print("searchTodosWithAsync response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func addATodoWithAsync() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response = try await TodosAPI.addATodoWithAsync(
                    title: "async 테스트", isDone: true)
                print("addATodoWithAsync response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func addATodoJsonWithAsync() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response = try await TodosAPI.addATodoJsonWithAsync(
                    title: "async 테스트2", isDone: false)
                print("addATodoJsonWithAsync response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func editATodoJsonWithAsync() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response = try await TodosAPI.editATodoJsonWithAsync(
                    id: 7211, title: "async 테스트0", isDone: false)
                print("editATodoJsonWithAsync response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func editATodoPutWithAsync() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response = try await TodosAPI.editATodoPutWithAsync(
                    id: 7211, title: "async 테스트00", isDone: false)
                print("editATodoPutWithAsync response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func deleteATodoWithAsync() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response = try await TodosAPI.deleteATodoWithAsync(id: 7211)
                print("deleteATodoWithAsync response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func addATodoAndFetchTodosWithAsync_2() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response =
                    try await TodosAPI.addATodoAndFetchTodosWithAsync_2(
                        title: "hello world")
                print("addATodoAndFetchTodosWithAsync_2 response: \(response)")
            } catch {
                self.handleError(error)
            }
        }
    }

    func addATodoAndFetchTodosWithAsync_2_NoError() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            let response =
                await TodosAPI.addATodoAndFetchTodosWithAsync_2_NoError(
                    title: "hello world")
            print(
                "addATodoAndFetchTodosWithAsync_2_NoError response: \(response)"
            )
        }
    }

    func deleteSelectedTodosWithAsync_NoError() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            let response = await TodosAPI.deleteSelectedTodosWithAsync_NoError(
                selectedTodoIds: [])
            print("deleteSelectedTodosWithAsync_NoError response: \(response)")
        }
    }

    func deleteSelectedTodosWithAsyncWithError() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response =
                    try await TodosAPI.deleteSelectedTodosWithAsyncWithError(
                        selectedTodoIds: [])
                print(
                    "deleteSelectedTodosWithAsyncWithError response: \(response)"
                )
            } catch {
                self.handleError(error)
            }
        }
    }

    func deleteSelectedTodosWithAsyncTaaskGroupWithError() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response =
                    try await TodosAPI
                    .deleteSelectedTodosWithAsyncTaaskGroupWithError(
                        selectedTodoIds: [6693, 6435, 6179, 6682])
                print(
                    "deleteSelectedTodosWithAsyncTaaskGroupWithError response: \(response)"
                )
            } catch {
                self.handleError(error)
            }
        }
    }

    func deleteSelectedTodosWithAsyncTaaskGroupWithNoError() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            let response =
                await TodosAPI.deleteSelectedTodosWithAsyncTaaskGroupWithNoError(
                    selectedTodoIds: [6693, 6435, 6179, 6682])
            print(
                "deleteSelectedTodosWithAsyncTaaskGroupWithNoError response: \(response)"
            )
        }
    }

    func fetchSelectedTodosWithAsyncNoError() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            let response = await TodosAPI.fetchSelectedTodosWithAsyncNoError(
                selectedTodoIds: [6693, 6676, 6675])
            print("fetchSelectedTodosWithAsyncNoError response: \(response)")
        }
    }

    func fetchSelectedTodosWithAsyncWithError() {
        // MARK: - 에러 처리하려면 try - do-catch
        Task {
            do {
                let response =
                    try await TodosAPI.fetchSelectedTodosWithAsyncWithError(
                        selectedTodoIds: [6676, 6179, 6179, 6682])
                print(
                    "fetchSelectedTodosWithAsyncWithError response: \(response)"
                )
            } catch {
                self.handleError(error)
            }
        }
    }
}

// MARK: - Closure -> Async
extension TodosVM {
    func fetchTodosClosureToAsync() {
        Task {
            let result = await TodosAPI.fetchTodosClosureToAsync(page: 1)
            print("result \(result)")

            /*
             switch result {
             case .success(let data):
             case .failure(let failure):
             }
             */

        }
    }

    func fetchTodosClosureToAsyncWithError() {
        Task {
            do {
                let result =
                    try await TodosAPI.fetchTodosClosureToAsyncWithError()
                print("result: \(result)")
            } catch {
                self.handleError(error)
            }
        }
    }
}

// MARK: - Closure -> RX
extension TodosVM {
    func fetchTodosClosureToObservable() {
        TodosAPI.fetchTodosClosureToObservable(page: 1)
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { value in
                    print("value: \(value)")
                },
                onError: { error in
                    print("error: \(error)")
                }
            ).disposed(by: disposeBag)
    }

    func fetchTodosClosureToObservableWithError() {
        TodosAPI.fetchTodosClosureToObservableWithError(page: 1)
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { value in
                    print("value: \(value)")
                },
                onError: { error in
                    print("error: \(error)")
                }
            ).disposed(by: disposeBag)
    }

    func fetchTodosClosureToObservableWithMapError() {
        TodosAPI.fetchTodosClosureToObservableWithMapError(page: 1)
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { value in
                    print("value: \(value)")
                },
                onError: { error in
                    print("error: \(error)")
                }
            ).disposed(by: disposeBag)
    }

    func fetchTodosClosureToObservableDataArray() {
        TodosAPI.fetchTodosClosureToObservableDataArray(page: 1)
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { value in
                    print("value: \(value)")
                },
                onError: { error in
                    print("error: \(error)")
                }
            ).disposed(by: disposeBag)
    }

    func fetchATodoClosureToObservableNoError() {
        TodosAPI.fetchATodoClosureToObservableNoError(id: 6424)
            .subscribe(
                // weak self해주자 현재는 사용안하기떄문에 경고없애려고 주석 [weak self]
                onNext: { value in
                    print("value: \(value)")
                },
                onError: { error in
                    print("error: \(error)")
                }
            ).disposed(by: disposeBag)
    }
}

// MARK: - Closure -> Combine Publisher
extension TodosVM {
    func fetchTodosClosureToPublisher() {
        TodosAPI.fetchTodosClosureToPublisher(page: 1)
            .sink { completion in
                switch completion {
                case .failure(let failure):
                    print("failure: \(failure)")
                case .finished:
                    print("finished")
                }
            } receiveValue: { response in
                print("response: \(response)")
            }
            // 메모리 관리를 위해 찌꺼기 정리
            .store(in: &subscriptions)
    }

    func fetchTodosClosureToPublisherMapError() {
        TodosAPI.fetchTodosClosureToPublisherMapError(page: 1)
            .sink { completion in
                switch completion {
                case .failure(let failure):
                    print("failure: \(failure)")
                case .finished:
                    print("finished")
                }
            } receiveValue: { response in
                print("response: \(response)")
            }
            // 메모리 관리를 위해 찌꺼기 정리
            .store(in: &subscriptions)
    }

    func fetchTodosClosureToPublisherNoError() {
        TodosAPI.fetchTodosClosureToPublisherMapError(page: 1)
            .sink { completion in
                switch completion {
                case .failure(let failure):
                    print("failure: \(failure)")
                case .finished:
                    print("finished")
                }
            } receiveValue: { response in
                print("response: \(response)")
            }
            // 메모리 관리를 위해 찌꺼기 정리
            .store(in: &subscriptions)
    }

    func fetchTodosClosureToPublisherNoError2() {
        TodosAPI.fetchTodosClosureToPublisherNoError2(page: 1)
            .sink { completion in
                switch completion {
                case .failure(let failure):
                    print("failure: \(failure)")
                case .finished:
                    print("finished")
                }
            } receiveValue: { response in
                print("response: \(response)")
            }
            // 메모리 관리를 위해 찌꺼기 정리
            .store(in: &subscriptions)
    }
}

// MARK: - Combine -> Async
extension TodosVM {
    func fetchTodosWithPublisherToAsync() {
        Task {
            do {
                let result = try await TodosAPI.fetchTodosWithPublisherToAsync(
                    page: 1)
                print("result: \(result)")
            } catch {
                self.handleError(error)
            }
        }
    }

    // MARK: - extension버전
    func fetchTodosWithPublisherToAsyncExtension() {
        Task {
            do {
                let result = try await TodosAPI.fetchTodosWithPublisher(page: 1)
                    .toAsync()
                print("result: \(result)")
            } catch {
                self.handleError(error)
            }
        }
    }
}

// MARK: - Rx -> Async
extension TodosVM {
    func fetchTodosWithObservableToAsync() {
        Task {
            do {
                let result = try await TodosAPI.fetchTodosWithObservableToAsync(
                    page: 1)
                print("result: \(result)")
            } catch {
                self.handleError(error)
            }
        }
    }
    
    func fetchTodosWithObservableToAsyncExtension() {
        Task {
            do {
                let result = try await TodosAPI.fetchTodosWithObservable(
                    page: 1).toAsync()
                print("result: \(result)")
            } catch {
                self.handleError(error)
            }
        }
    }
    
    func fetchTodoWithObservableToAsync() {
        Task {
            do {
                let result = try await TodosAPI.fetchTodoWithObservableToAsync(
                    page: 1)
                print("result: \(result)")
            } catch {
                self.handleError(error)
            }
        }
    }
}


// MARK: - RxCombine
extension TodosVM {
    // MARK: - Rx -> Combine
    func fetchTodosWithObservable를Combine으로() {
        TodosAPI.fetchTodosWithObservable()
            .publisher
            .sink { conpletion in
                switch conpletion {
                case .finished:
                    print("finished")
                case .failure(let failure):
                    print("failed: \(failure)")
                }
            } receiveValue: { response in
                print(response)
            }.store(in: &subscriptions)
    }
    
    // MARK: - Combine -> Rx
    func fetchTodosWithPublisher를Async로(page: Int) {
        TodosAPI.fetchTodosWithPublisher(page: page)
            .asObservable()
            .subscribe(onNext: {
                print("onNext: \($0)")
            }, onError: {
                print("onError: \($0)")
            }, onCompleted: {
                print("onCompleted: 스트림 끊김 종료")
            }, onDisposed: {
                print("onDisposed: 완전히 제거")
            })
            .disposed(by: disposeBag)
    }
}
