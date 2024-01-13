import Fluent
import Vapor

extension DatabaseTreeRepository {
    func has(_ id: UUID) async throws -> Bool {
        try await byID(id).first() != nil
    }
}
