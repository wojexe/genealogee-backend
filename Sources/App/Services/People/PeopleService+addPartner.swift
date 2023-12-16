import Fluent
import Vapor

extension PeopleService {
    @discardableResult
    func addPartner(personID: UUID, partnerID: UUID) async throws -> Family.Created {
        let person = try await Person
            .query(on: req.db)
            .filter(\.$id == personID)
            .with(\.$family)
            .first()!

        guard let family = person.family.first else {
            throw Abort(.internalServerError)
        }

        let familyID = try family.requireID()

        try await req.familiesService.addParent(familyID: familyID, parentID: partnerID)

        return try await Family.Created(family, req.db)
    }
}
