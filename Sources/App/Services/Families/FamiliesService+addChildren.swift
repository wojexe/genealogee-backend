import Fluent
import Vapor

extension FamiliesService {
    func addChildren(familyID: UUID, childIDs: [UUID], on db: Database? = nil) async throws {
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
            .with(\.$children)
            .first()
        else {
            throw Abort(.notFound, reason: "Family with ID '\(familyID)' not found")
        }

        let children = try await personRepository
            .byIDs(childIDs)
            .filter(\.$tree.$id == family.tree.requireID())
            .all()

        guard childIDs.count == children.count else {
            throw Abort(.notFound, reason: "One or more people not found")
        }

        let attachableChildren = children.filter { child in
            !family.children.contains { $0.id == child.id }
        }

        try await family.$children.attach(attachableChildren, on: db)
    }
}
