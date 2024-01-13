import Fluent
import Vapor

extension DatabasePersonRepository {
    func has(_ id: UUID) async throws -> Bool {
        try await byID(id).first() != nil
    }

    func has(_ ids: [UUID]) async throws -> Bool {
        try await byIDs(ids).count() == ids.count
    }
}
