import Fluent
import Vapor

extension FamiliesService {
    func addChild(familyID: UUID, childID: UUID) async throws {
        try await addChildren(familyID: familyID, childIDs: [childID])
    }
}
