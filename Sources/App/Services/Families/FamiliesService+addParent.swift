import Fluent
import Vapor

extension FamiliesService {
    func addParent(familyID: UUID, parentID: UUID) async throws {
        try await addParents(familyID: familyID, parentIDs: [parentID])
    }
}
