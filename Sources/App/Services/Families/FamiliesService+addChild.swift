import Fluent
import Vapor

extension FamiliesService {
    func addChild(familyID: UUID, childID: UUID, on db: Database? = nil) async throws {
        try await addChildren(familyID: familyID, childIDs: [childID], on: db ?? req.db)
    }
}
