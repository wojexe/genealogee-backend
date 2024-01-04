import Fluent
import Vapor

extension PeopleService {
    @discardableResult
    func addChild(personID: UUID, childID: UUID) async throws -> Family.Created {
        let person = try await req.people.get(personID)

        guard let family = try await person.$family.get(on: req.db).first else {
            throw Abort(.internalServerError, reason: "This person does not have a family")

            // TODO: decide if it's better to create the family or not.
        }

        let familyID = try family.requireID()

        try await req.familiesService.addChild(familyID: familyID, childID: childID)

        return try await Family.Created(family, req.db)
    }
}
