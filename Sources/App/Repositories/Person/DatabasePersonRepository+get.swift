import Fluent
import Vapor

extension DatabasePersonRepository {
    func get(_ id: UUID) async throws -> Person {
        let query = try scoped(by: .currentUser)
            .filter(\.$id == id)

        guard let result = try await query.first() else {
            throw Abort(.notFound, reason: "No such person exists")
        }

        return result
    }
}
