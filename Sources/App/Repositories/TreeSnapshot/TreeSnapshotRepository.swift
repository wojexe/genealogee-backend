import Fluent
import Vapor

enum TreeSnapshotRepositoryScope {
    case currentUser
    case user(UUID)
    case none
}

enum TreeSnapshotRepositoryGetBy {
    case treeID(UUID)
    case snapshotID(UUID)
}

protocol TreeSnapshotRepository {
    var req: Request { get }

    init(req: Request)

    func scoped(by scope: TreeSnapshotRepositoryScope) throws -> QueryBuilder<TreeSnapshot>
    func get(by: TreeSnapshotRepositoryGetBy) async throws -> TreeSnapshot
}

struct TreeSnapshotRepositoryFactory {
    var make: ((Request) -> TreeSnapshotRepository)?
    mutating func use(_ make: @escaping ((Request) -> TreeSnapshotRepository)) {
        self.make = make
    }
}

extension Application {
    private struct TreeSnapshotRepositoryKey: StorageKey {
        typealias Value = TreeSnapshotRepositoryFactory
    }

    var treeSnapshots: TreeSnapshotRepositoryFactory {
        get {
            storage[TreeSnapshotRepositoryKey.self] ?? .init()
        }
        set {
            storage[TreeSnapshotRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var treeSnapshots: TreeSnapshotRepository {
        application.treeSnapshots.make!(self)
    }
}
