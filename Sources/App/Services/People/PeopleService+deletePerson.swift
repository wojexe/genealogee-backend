import Fluent
import Vapor

extension PeopleService {
    func deletePerson(_ id: UUID) async throws {
        let person = try await req.people.get(id)

        try await person.nuke(on: req.db)
    }
}
