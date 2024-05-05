import Fluent
import Vapor

final class Family: Model, Content {
    static let schema = "families"

    @ID
    var id: UUID?

    @Parent(key: "creator_id")
    var creator: User

    @Parent(key: "tree_id")
    var tree: Tree

    @Children(for: \.$family)
    var parents: [Person]

    @Children(for: \.$parentFamily)
    var children: [Person]

    init() {}

    init(id: UUID? = nil, creatorID: UUID, treeID: UUID) {
        self.id = id
        $creator.id = creatorID
        $tree.id = treeID
    }

    /// Delete people at the parent level and all children recursively
    func nuke(on db: Database) async throws {
        try await db.transaction { db in
            let tree = try await self.$tree.get(on: db)
            let parents = try await self.$parents.get(on: db)
            let children = try await self.$children.get(on: db)

            try await parents.delete(on: db)

            for child in children {
                try await child.nuke(on: db)
            }

            if (tree.rootFamilyID == self.id) {
                tree.rootFamilyID = nil
                try await tree.save(on: db)
            }

            try await self.delete(on: db)
        }
    }

    struct DTO {}
}
