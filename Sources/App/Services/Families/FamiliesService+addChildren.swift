import Fluent
import Vapor

extension FamiliesService {
    func addChildren(familyID: UUID, childIDs: [UUID], on db: Database? = nil) async throws {
        let db = db ?? req.db

        guard let family = try await req
            .families
            .using(db)
            .byID(familyID)
            .with(\.$tree)
            .with(\.$children)
            .first()
        else {
            throw Abort(.notFound, reason: "Family with ID '\(familyID)' not found")
        }

        let children = try await req
            .people
            .using(db)
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
