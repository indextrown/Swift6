import Foundation

// MARK: - Entity
struct Entity {
    let id: Int
}

// MARK: - Domain
protocol RepositoryProtocol { // ✅ protocol로 변경
    func fetchList() -> [Entity]
}

class UseCase { // 고수준
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> [Entity] {
        return repository.fetchList()
    }
}

// MARK: - Data (저수준)
class Repository: RepositoryProtocol {
    func fetchList() -> [Entity] {
        // 예시: 진짜 DB 또는 API에서 가져오는 로직
        return [Entity(id: 1), Entity(id: 2)]
    }
}

class Mockository: RepositoryProtocol {
    func fetchList() -> [Entity] {
        // 테스트용 더미 데이터
        return [Entity(id: 999), Entity(id: 1000)]
    }
}

// MARK: - Presentation
class ViewModel {
    private let useCase: UseCase
    
    init(useCase: UseCase) {
        self.useCase = useCase
    }
    
    func printList() {
        let list = useCase.execute()
        list.forEach { print("Entity ID: \($0.id)") }
    }
}

// MARK: - 실행
let mockRepository = Mockository()
let useCase = UseCase(repository: mockRepository)
let viewModel = ViewModel(useCase: useCase)

viewModel.printList()  // 출력: 999, 1000
