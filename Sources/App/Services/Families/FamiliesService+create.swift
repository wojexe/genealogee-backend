import Fluent
import Vapor

extension FamiliesService {
    func create(treeID: UUID, on db: Database?) async throws -> Family {
        let db = db ?? req.db

        let userID = try req.auth.require(User.self).requireID()

        let family = Family(creatorID: userID, treeID: treeID)

        try await family.save(on: db)

        return family
    }
}
