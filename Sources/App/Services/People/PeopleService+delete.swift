import Fluent
import Vapor

extension PeopleService {
    func delete(_ personID: UUID) async throws {
        let person = try await req.people.get(personID)

        try await person.nuke(on: req.db)
    }
}
