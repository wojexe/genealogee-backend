import Fluent
import Vapor

extension FamilyOperations {
    static func AddParent(familyID: UUID, parentID: UUID, on db: Database) async throws {
        try await ParentLink(familyID: familyID, personID: parentID).save(on: db)
    }
}
