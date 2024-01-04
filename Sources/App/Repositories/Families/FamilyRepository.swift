import Fluent
import Vapor

enum FamilyRepositoryScope {
    case currentUser
    case user(UUID)
    case none
}

protocol FamilyRepository {
    var req: Request { get }

    init(req: Request)

    func scoped(by scope: FamilyRepositoryScope) throws -> QueryBuilder<Family>
    func get(_ id: UUID) async throws -> Family
}

struct FamilyRepositoryFactory {
    var make: ((Request) -> FamilyRepository)?
    mutating func use(_ make: @escaping ((Request) -> FamilyRepository)) {
        self.make = make
    }
}

extension Application {
    private struct FamilyRepositoryKey: StorageKey {
        typealias Value = FamilyRepositoryFactory
    }

    var families: FamilyRepositoryFactory {
        get {
            storage[FamilyRepositoryKey.self] ?? .init()
        }
        set {
            storage[FamilyRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var families: FamilyRepository {
        application.families.make!(self)
    }
}
