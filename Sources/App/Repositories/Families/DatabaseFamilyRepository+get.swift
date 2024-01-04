import Fluent
import Vapor

extension DatabaseFamilyRepository {
    func get(_ id: UUID) async throws -> Family {
        let query = try scoped(by: .currentUser)
            .filter(\.$id == id)

        guard let result = try await query.first() else {
            throw Abort(.notFound, reason: "No such family exists")
        }

        return result
    }
}
