import Fluent
import Vapor

extension FamiliesService {
    func addChild(familyID: UUID, childID: UUID) async throws {
        try await ChildLink(familyID: familyID, personID: childID).save(on: req.db)
    }
}
