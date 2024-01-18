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
                .filter(\.$id == family.requireID())
                .with(\.$parents)
                .with(\.$children)
                .first()!

            id = try family.requireID()
            creatorID = family.$creator.id
            treeID = family.$tree.id
            parents = try family.parents.map { try $0.requireID() }
            children = try family.children.map { try $0.requireID() }
        }
    }
}
