import Fluent
import Vapor

extension FamiliesService {
    func addParents(familyID: UUID, parentIDs: [UUID], on db: Database? = nil) async throws {
        let db = db ?? req.db

        req.logger.info("Custom repo in transaction: \(db.inTransaction)")

        guard let family = try await req
            .families
            .using(db)
            .byID(familyID)
            .with(\.$tree)
            .with(\.$parents)
            .first()
        else {
            throw Abort(.notFound, reason: "Family with ID '\(familyID)' not found")
        }

        let parents = try await req
            .people
            .using(db)
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
