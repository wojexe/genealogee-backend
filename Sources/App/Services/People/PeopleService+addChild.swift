import Fluent
import Vapor

extension PeopleService {
    @discardableResult
    func addChild(personID: UUID, childID: UUID, on db: Database? = nil) async throws -> Family {
        try await addRelative(personID: personID, .child(childID), on: db ?? req.db)
    }
}
