import Fluent
import Vapor

extension FamiliesService {
    func createFamily(treeID: UUID, parents: [UUID] = [], children: [UUID] = []) async throws -> Family {
        let userID = try req.auth.require(User.self).requireID()

        let family = Family(creatorID: userID, treeID: treeID)

        try await family.save(on: req.db)

        let familyID = try family.requireID()

        try await req.familiesService.addChildren(familyID: familyID, childIDs: children)
        try await req.familiesService.addParents(familyID: familyID, parentIDs: parents)

        return family
    }
}
