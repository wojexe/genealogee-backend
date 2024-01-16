import Fluent
import Vapor

extension DatabaseFamilyRepository {
    func has(_ familyID: UUID, _ relation: FamilyRepositoryRelation) async throws -> Bool {
        let family = try await get(familyID)

        switch relation {
        case let .child(childID):
            return try await family.$children.isAttached(toID: childID, on: req.db)

        case let .parent(parentID):
            return try await family.$parents.isAttached(toID: parentID, on: req.db)

        case let .any(personID):
            let isChild = try await family.$children.isAttached(toID: personID, on: req.db)
            let isParent = try await family.$parents.isAttached(toID: personID, on: req.db)

            return isChild || isParent
        }
    }
}
