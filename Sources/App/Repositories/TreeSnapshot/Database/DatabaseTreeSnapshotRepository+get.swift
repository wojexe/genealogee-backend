import Fluent
import Vapor

extension DatabaseTreeSnapshotRepository {
    func get(by: TreeSnapshotRepositoryGetBy) async throws -> TreeSnapshot {
        switch by {
        case let .treeID(id):
            try await getByTreeID(id)
        case let .snapshotID(id):
            try await getBySnapshotID(id)
        }
    }

    private func getByTreeID(_ id: UUID) async throws -> TreeSnapshot {
        let query = try scoped(by: .currentUser)
            .filter(\.$tree.$id == id)
            .sort(\.$createdAt, .descending) // Sort by most recent

        guard let result = try await query.first() else {
            throw Abort(.notFound, reason: "Tree has no snapshots yet")
        }

        return result
    }

    private func getBySnapshotID(_ id: UUID) async throws -> TreeSnapshot {
        let query = try scoped(by: .currentUser)
            .filter(\.$id == id)

        guard let result = try await query.first() else {
            throw RepositoryError.notFound(id, TreeSnapshot.self)
        }

        return result
    }
}
