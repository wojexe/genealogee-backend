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

    @Siblings(through: ParentLink.self, from: \.$id.$family, to: \.$id.$person)
    var parents: [Person]

    @Siblings(through: ChildLink.self, from: \.$id.$family, to: \.$id.$person)
    var children: [Person]

    init() {}

    init(id: UUID? = nil, creatorID: UUID, treeID: UUID) {
        self.id = id
        $creator.id = creatorID
        $tree.id = treeID
    }

    /// Delete people at the parent level and all children recursively
    func nuke(on _: Database) async throws {
        // let parents = try await self.$parents.get(on: db)
        // let children = try await self.$children.get(on: db)

        // TODO: Nuke all children
        // TODO: Delete all parents
    }
}
