import Fluent
import Vapor

extension FamilyOperations {
    static func AddChild(familyID: UUID, childID: UUID, on db: Database) async throws {
        try await ChildLink(familyID: familyID, personID: childID).save(on: db)
    }
}
