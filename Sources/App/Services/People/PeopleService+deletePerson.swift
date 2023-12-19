import Fluent
import Vapor

extension PeopleService {
    // TODO: scope for user
    func deletePerson(_ id: UUID) async throws {
        let person = try await Person
            .query(on: req.db)
            .filter(\.$id == id)
            .with(\.$family) { $0.with(\.$children).with(\.$parents) }
            .first()!

        try await person.nuke(on: req.db) // Not implemented yet
    }
}
