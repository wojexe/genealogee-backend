import Fluent
import Vapor

extension FamiliesService {
    func addParent(familyID: UUID, parentID: UUID, on db: Database? = nil) async throws {
        try await addParents(familyID: familyID, parentIDs: [parentID], on: db ?? req.db)
    }
}
