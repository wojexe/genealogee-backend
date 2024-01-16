import Fluent
import Vapor

extension DatabaseFamilyRepository {
    func get(_ id: UUID) async throws -> Family {
        let query = try byID(id)

        guard let result = try await query.first() else {
            throw RepositoryError.notFound(id, Family.self)
        }

        return result
    }
}
