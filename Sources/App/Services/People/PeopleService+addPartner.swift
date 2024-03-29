import Fluent
import Vapor

extension PeopleService {
    @discardableResult
    func addPartner(personID: UUID, partnerID: UUID, on db: Database? = nil) async throws -> Family {
        try await addRelative(personID: personID, .partner(partnerID), on: db ?? req.db)
    }
}
