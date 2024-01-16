import Fluent
import Vapor

extension FamiliesService {
    func addRelatives(familyID: UUID, _ relatives: RelationMultiple, on db: Database? = nil) async throws {
        let db = db ?? req.db

        let familyRepository = getFamilyRepository(db)
        let personRepository = getPersonRepository(db)

        guard let family = try await familyRepository
            .byID(familyID)
            .with(\.$tree)
            .with(\.$children)
            .with(\.$parents)
            .first()
        else {
            throw RepositoryError.notFound(familyID, Family.self)
        }

        let relativeIDs = switch relatives {
        case let .children(children): children
        case let .parents(parents): parents
        }

        let relativeRecords = try await personRepository.get(relativeIDs)

        guard relativeIDs.count == relativeRecords.count else {
            throw RepositoryError.notFoundMultiple(relativeIDs, Person.self)
        }

        let attachableRelatives = relativeRecords.filter { relative in
            switch relatives {
            case .children:
                !family.children.contains { $0.id == relative.id }
            case .parents:
                !family.parents.contains { $0.id == relative.id }
            }
        }

        switch relatives {
        case .children:
            try await family.$children.attach(attachableRelatives, on: db)
        case .parents:
            try await family.$parents.attach(attachableRelatives, on: db)
        }
    }
}
