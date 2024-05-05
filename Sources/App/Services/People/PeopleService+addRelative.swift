import Fluent
import Vapor

extension PeopleService {
    @discardableResult
    func addRelative(personID: UUID, _ relative: Relation, on db: Database? = nil) async throws -> Family {
        let db = db ?? req.db

        let relativeID = switch relative {
        case let .child(childID): childID
        case let .partner(partnerID): partnerID
        }

        let personRepository = getPersonRepository(db)

        let people = try await personRepository
            .byIDs([personID, relativeID])
            .with(\.$tree)
            .with(\.$family)
            .all()

        guard people.count == 2 else {
            throw Abort(.badRequest, reason: "One or more people not found")
        }

        let personWithFamily = people.first { $0.id == personID }!
        let personToBeAttached = people.first { $0.id == relativeID }!

        guard personWithFamily.tree.id == personToBeAttached.tree.id else {
            throw Abort(.badRequest, reason: "People are not in the same tree")
        }

        let family = try await db.transaction { db in
            let family = personWithFamily.family

            switch relative {
            case .child:
                personToBeAttached.parentFamily = family
            case .partner:
                personToBeAttached.family = family
            }

            try await personToBeAttached.update(on: db)

            return family
        }

        return family
    }
}
