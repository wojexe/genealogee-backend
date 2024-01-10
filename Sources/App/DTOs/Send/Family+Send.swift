import Fluent
import Vapor

extension Family.DTO {
    struct Send: Content {
        let id: UUID
        let creatorID: UUID
        let treeID: UUID
        let parents: [UUID]
        let children: [UUID]

        init(_ family: Family, on db: Database) async throws {
            let family = try await Family.query(on: db)
                .with(\.$creator)
                .with(\.$tree)
                .with(\.$parents)
                .with(\.$children)
                .filter(\.$id == family.requireID())
                .first()!

            id = try family.requireID()
            creatorID = try family.creator.requireID()
            treeID = try family.tree.requireID()
            parents = try family.parents.map { try $0.requireID() }
            children = try family.children.map { try $0.requireID() }
        }
    }
}
