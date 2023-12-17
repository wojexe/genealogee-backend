import Fluent
import Vapor

enum TreeRepositoryScope {
    case currentUser
    case user(UUID)
    case none
}

protocol TreeRepository {
    // var db: Database { get }
    var req: Request { get }

    // init(db: Database)
    init(req: Request)

    func scoped(by scope: TreeRepositoryScope) throws -> QueryBuilder<Tree>
}

struct TreeRepositoryFactory {
    var make: ((Request) -> TreeRepository)?
    mutating func use(_ make: @escaping ((Request) -> TreeRepository)) {
        self.make = make
    }
}

extension Application {
    private struct TreeRepositoryKey: StorageKey {
        typealias Value = TreeRepositoryFactory
    }

    var trees: TreeRepositoryFactory {
        get {
            storage[TreeRepositoryKey.self] ?? .init()
        }
        set {
            storage[TreeRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var trees: TreeRepository {
        application.trees.make!(self)
    }
}
