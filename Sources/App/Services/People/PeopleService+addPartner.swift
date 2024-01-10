import Fluent
import Vapor

extension PeopleService {
    @discardableResult
    func addPartner(personID: UUID, partnerID: UUID) async throws -> Family.DTO.Send {
        let person = try await req.people.get(personID)
        let partner = try await req.people.get(partnerID)

        guard let family = try await person.$family.get(on: req.db).first else {
            throw Abort(.internalServerError, reason: "Person with ID '\(personID)' does not have a family")
        }

        try await family.$parents.attach(partner, on: req.db)

        return try await Family.DTO.Send(family, on: req.db)
    }
}
