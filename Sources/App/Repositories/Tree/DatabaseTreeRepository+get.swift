import Fluent
import Vapor

extension DatabaseTreeRepository {
    func get(id: UUID, entire _: Bool = false) async throws -> Tree {
        let query = try scoped(by: .currentUser)
            .filter(\.$id == id)
            .with(\.$people)
            .with(\.$families)

        guard let result = try await query.first() else {
            throw Abort(.notFound, reason: "No such tree exists")
        }

        return result
    }
}
