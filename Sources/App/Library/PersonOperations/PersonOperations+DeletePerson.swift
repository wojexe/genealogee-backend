import Fluent
import Vapor

extension PersonOperations {
    static func DeletePerson(_ id: UUID, on db: Database) async throws {
        let person = try await Person
            .query(on: db)
            .filter(\.$id == id)
            .with(\.$family) { $0.with(\.$children).with(\.$parents) }
            .first()!

        try await person.nuke(on: db) // Not implemented yet
    }
}
