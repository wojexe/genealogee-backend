import Fluent
import Vapor

extension PeopleService {
    func deletePerson(_ id: UUID) async throws {
        guard let person = try? await req.people.get(id) else {
            throw Abort(.notFound, reason: "No such person exists")
        }

        try await person.nuke(on: req.db)
    }
}
