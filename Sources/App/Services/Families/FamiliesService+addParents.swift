import Fluent
import Vapor

extension FamiliesService {
    func addParents(familyID: UUID, parentIDs: [UUID], on db: Database? = nil) async throws {
        let db = db ?? req.db

        let familyRepository = if let families = req.families as? DatabaseFamilyRepository {
            families.using(db)
        } else {
            req.families
        }

        let personRepository = if let people = req.people as? DatabasePersonRepository {
            people.using(db)
        } else {
            req.people
        }

        guard let family = try await familyRepository
            .byID(familyID)
            .with(\.$tree)
            .with(\.$parents)
            .first()
        else {
            throw Abort(.notFound, reason: "Family with ID '\(familyID)' not found")
        }

        let parents = try await personRepository
            .byIDs(parentIDs)
            .filter(\.$tree.$id == family.tree.requireID())
            .all()

        guard parentIDs.count == parents.count else {
            throw Abort(.notFound, reason: "One or more people not found")
        }

        let attachableParents = parents.filter { parent in
            !family.parents.contains { $0.id == parent.id }
        }

        try await family.$parents.attach(attachableParents, on: db)
    }
}
