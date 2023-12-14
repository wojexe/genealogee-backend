import Fluent
import Vapor

extension PersonOperations {
    static func AddPartner(personID: UUID, partnerID: UUID, on db: Database) async throws {
        let person = try await Person
            .query(on: db)
            .filter(\.$id == personID)
            .with(\.$family)
            .first()!

        guard let family = person.family.first else {
            throw Abort(.internalServerError)
        }

        let familyID = try family.requireID()

        try await FamilyOperations.AddParent(familyID: familyID, parentID: partnerID, on: db)
    }
}
