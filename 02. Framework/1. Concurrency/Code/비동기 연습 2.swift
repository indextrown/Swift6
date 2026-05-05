//
//  test.swift
//  Swift5
//
//  Created by 김동현 on 3/11/25.
//

import Foundation

// https://dummy.restapiexample.com/
// https://dummy.restapiexample.com/api/v1/employees

extension String: @retroactive Error { }


// user
struct User: Codable {
    let status: String
    let employees: [Employee]
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case employees = "data"
        case message
    }
}

// employee
struct Employee: Codable {
    let id: Int
    let employeeName: String
    let employeeSalary, employeeAge: Int
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
        case profileImage = "profile_image"
    }
}

// MARK: - 기존 URLSession 방식(직관적이지 않고 불편함..)
class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    // MARK: - 기존의 GCD는 콜백방식으로 함수를 설계(return이 아닌 escaping 클로저를 사용하여 언젠가 생길 데이터를 콜백 함수를 호출하여 전달)
    // 함수만 보고 비동기함수인지 판단하기 어려움 ===> 콜백함수가 나중에 호출됨 (나중에 일함)
    func fetchUser(completion: @escaping (User?, Error?) -> Void) {
                                        // 정상이면 User? 에러면 Error 반환
        
        let url = URL(string: "https://dummy.restapiexample.com/api/v1/employees")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                //print("네트워크 에러 발생")
                completion(nil, "네트워크 에러 발생")  // 콜백함수 호출 잊을수도 있음 ==> 오류 생길 가능성
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                //print("서버 응답 에러")
                completion(nil, "서버 응답 에러")   // 콜백함수 호출 잊을수도 있음 ==> 오류 생길 가능성
                return
            }
            
            guard let safeData = data else {
                //print("데이터 언래핑 에러")
                completion(nil, "데이터 언래핑 에러")   // 콜백함수 호출 잊을수도 있음 ==> 오류 생길 가능성
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: safeData)
                completion(user, nil)  // 콜백함수 호출 잊을수도 있음 ==> 오류 생길 가능성
                return
            } catch {
                //print("데이터 변환 에러")
                completion(nil, "데이터 변환 에러")   // 콜백함수 호출 잊을수도 있음 ==> 오류 생길 가능성
                return
            }
        }.resume()
    }
}

class ViewModel {
    var user: User?
    
    func fetchUser() {             /// 캡처현상 때문에 ===> 캡처리스트 사용 (항상은 아니지만 일반적으로)
        // MARK: - escaping 클로저라서 실제 이함수를호출하는 곳에서 캡처현상이 발생할 수 있다
        /*
         외부의 변수(user) 즉 self가 보유한 user가 생긴 시점에 user를 전달해야해서 self를 캡처할수있다
         self를 오래동안 붙잡기 싫으면 weak self
         
         오래동안 붙잡는다(strong capture):
         클로저가 실행되는 동안 self를 계속 메모리에 유지시킵니다. 이 경우, 네트워크 요청이 오래 걸리거나 클로저가 오래 살아있다면, 불필요하게 메모리를 잡고 있을 수 있습니다.
         
         붙잡지 않는다(weak capture):
         self가 필요 없을 때는 해제될 수 있도록 하여 메모리 누수와 순환 참조를 방지합니다.
         단, self가 nil일 가능성을 고려해야 하므로, 클로저 내에서 옵셔널 처리를 해야 합니다.
         */
        NetworkService.shared.fetchUser { [weak self] (user, error) in
            guard error == nil else {
                let errorString = error as! String
                print(errorString)
                return
            }
            
            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }
}



/// 비동기적인 일처리도 리턴타입으로 함수 설계 가능

class NetworkService2 {
    static let shared = NetworkService2()
    private init() {}
    
    /// ====================================================================
    /// 리턴타입을 가지는 함수로 설계 가능 (일단 에러 처리 제외)
    func fetchUser2() async -> User? {
        
        let url = URL(string: "https://dummy.restapiexample.com/api/v1/employees")!
        
        do {
            // 오래 걸리는 코드, 실행 -> 일시정지 -> 실행 -> (data, response)에 저장
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("서버 응답 에러")
                return nil
            }
            
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// (에러 처리 포함 한다면)
    
    func fetchUser() async throws -> User? {
        
        let url = URL(string: "https://dummy.restapiexample.com/api/v1/employees")!

        /// 함수 호출시 try await 붙여야함 (순서대로) / 기다렸다가 ===> 에러체크
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "서버 응답 에러"
        }
        
        guard let user = try? JSONDecoder().decode(User.self, from: data) else {
            throw "데이터 변환 에러"
        }
        
        return user
    }
    
}


class ViewModel2 {
    
    var user: User?
    
    func fetchUser() {
        Task {
            let user = try await NetworkService2.shared.fetchUser()
            
            DispatchQueue.main.async {
                self.user = user
            }
            
            /// 메인쓰레드로 돌아가게 한 후 일이 끝날때까지 기다리는 것
            /// (메인쓰레드로 바로 진입 후, 일의 발생이 끝나는 것을 기다리는 것)
            /// 메인 액터는 (반드시) 메인쓰레드에서 실행되는 액터(Actor) 타입
            /// DispatchQueue.main의 새로운 대체제
            await MainActor.run {
                self.user = user
            }
        }
    }
    
    
    func fetchUser2() {
        Task {
            do {
                let user = try await NetworkService2.shared.fetchUser2()
                
                await MainActor.run {
                    self.user = user
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

