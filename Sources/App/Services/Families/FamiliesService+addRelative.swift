import Fluent
import Vapor

extension FamiliesService {
    func addRelative(familyID: UUID, _ relative: Relation, on db: Database? = nil) async throws {
        switch relative {
        case let .child(childID):
            try await addRelatives(familyID: familyID, .children([childID]), on: db ?? req.db)
        case let .partner(partnerID):
            try await addRelatives(familyID: familyID, .parents([partnerID]), on: db ?? req.db)
        }
    }
}
