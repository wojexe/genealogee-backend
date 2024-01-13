import Fluent
import Vapor

enum PersonRepositoryScope {
    case currentUser
    case user(UUID)
    case none
}

protocol PersonRepository {
    var req: Request { get }
    var db: Database { get }

    init(req: Request, db: Database?)

    func using(_ db: Database) -> Self

    func scoped(by scope: PersonRepositoryScope) throws -> QueryBuilder<Person>

    func byID(_ id: UUID) throws -> QueryBuilder<Person>
    func byIDs(_ ids: [UUID]) throws -> QueryBuilder<Person>

    func get(_ id: UUID) async throws -> Person
    func get(_ ids: [UUID]) async throws -> [Person]

    func has(_ id: UUID) async throws -> Bool
    func has(_ ids: [UUID]) async throws -> Bool
}

struct PersonRepositoryFactory {
    var make: ((Request) -> PersonRepository)?
    mutating func use(_ make: @escaping ((Request) -> PersonRepository)) {
        self.make = make
    }
}

extension Application {
    private struct PersonRepositoryKey: StorageKey {
        typealias Value = PersonRepositoryFactory
    }

    var people: PersonRepositoryFactory {
        get {
            storage[PersonRepositoryKey.self] ?? .init()
        }
        set {
            storage[PersonRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var people: PersonRepository {
        application.people.make!(self)
    }
}
