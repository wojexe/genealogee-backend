import Fluent
import Vapor

extension PersonOperations {
    static func AddChild(personID: UUID, childID: UUID, on db: Database) async throws {
        let person = try await Person
            .query(on: db)
            .filter(\.$id == personID)
            .with(\.$family)
            .first()!

        guard let family = person.family.first else {
            throw Abort(.internalServerError)
        }

        let familyID = try family.requireID()

        try await FamilyOperations.AddChild(familyID: familyID, childID: childID, on: db)
    }
}
