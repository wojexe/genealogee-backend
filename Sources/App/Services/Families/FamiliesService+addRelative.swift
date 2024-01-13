import Fluent
import Vapor

extension FamiliesService {
    func addRelative(familyID: UUID, _ relative: Relation, on db: Database? = nil) async throws {
        switch relative {
        case let .child(childID):
            try await addChild(familyID: familyID, childID: childID, on: db ?? req.db)
        case let .partner(partnerID):
            try await addParent(familyID: familyID, parentID: partnerID, on: db ?? req.db)
        }
    }
}
