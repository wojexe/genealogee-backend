import Fluent
import Vapor

extension FamiliesService {
    func createFamily(treeID: UUID, parents: [UUID] = [], children: [UUID] = [], on db: Database?) async throws -> Family {
        let db = db ?? req.db

        let userID = try req.auth.require(User.self).requireID()

        let family = Family(creatorID: userID, treeID: treeID)

        try await family.save(on: db)

        if !children.isEmpty {
            req.logger.info("Adding children to family \(family.id!)")
            try await req.familiesService.addChildren(familyID: family.requireID(), childIDs: children, on: db)
        }

        if !parents.isEmpty {
            req.logger.info("Adding parents to family \(family.id!)")
            req.logger.info("parentIDs: \(parents)")
            req.logger.info("Database: \(db)")
            try await req.familiesService.addParents(familyID: family.requireID(), parentIDs: parents, on: db)
        }

        return family
    }
}
