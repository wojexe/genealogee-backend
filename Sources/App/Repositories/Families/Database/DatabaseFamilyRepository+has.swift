import Fluent
import Vapor

extension DatabaseFamilyRepository {
    func has(_ familyID: UUID, _ relation: FamilyRepositoryRelation) async throws -> Bool {
        guard let family = try? await byID(familyID)
            .with(\.$parents)
            .with(\.$children)
            .first()
        else {
            throw RepositoryError.notFound(familyID, Family.self)
        }

        switch relation {
        case let .child(childID):
            return try family.children.contains { try $0.requireID() == childID }

        case let .parent(parentID):
            return try family.parents.contains { try $0.requireID() == parentID }

        case let .any(personID):
            return try
                family.children.contains { try $0.requireID() == personID }
                || family.parents.contains { try $0.requireID() == personID }
        }
    }
}
