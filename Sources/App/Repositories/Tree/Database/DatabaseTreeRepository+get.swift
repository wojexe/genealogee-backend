import Fluent
import Vapor

extension DatabaseTreeRepository {
    func get(id: UUID) async throws -> Tree {
        let query = try byID(id)
            .with(\.$people)
            .with(\.$families)
            .with(\.$snapshots)

        guard let result = try await query.first() else {
            throw Abort(.notFound, reason: "No such tree exists")
        }

        return result
    }
}
