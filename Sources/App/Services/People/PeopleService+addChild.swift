import Fluent
import Vapor

extension PeopleService {
    @discardableResult
    func addChild(personID: UUID, childID: UUID) async throws -> Family.Created {
        guard let person = try await Person
            .query(on: req.db)
            .filter(\.$id == personID)
            .with(\.$family)
            .first()
        else {
            throw Abort(.badRequest, reason: "Person not found")
        }

        guard let family = try await person.$family.get(on: req.db).first else {
            throw Abort(.internalServerError, reason: "This person does not have a family")

            // TODO: decide if it's better to create the family or not.
        }

        let familyID = try family.requireID()

        try await req.familiesService.addChild(familyID: familyID, childID: childID)

        return try await Family.Created(family, req.db)
    }
}
