import Fluent
import Vapor

extension DatabaseTreeRepository {
    func get(id: UUID) async throws -> Tree {
        let query = try byID(id)
            .with(\.$people)
            .with(\.$families)
            .with(\.$snapshots)

        guard let result = try await query.first() else {
            throw RepositoryError.notFound(id, Tree.self)
        }

        return result
    }
}
