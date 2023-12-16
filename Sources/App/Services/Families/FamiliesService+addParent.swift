import Fluent
import Vapor

extension FamiliesService {
    func addParent(familyID: UUID, parentID: UUID) async throws {
        try await ParentLink(familyID: familyID, personID: parentID).save(on: req.db)
    }
}
