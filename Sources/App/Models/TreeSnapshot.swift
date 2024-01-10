import Fluent
import Vapor

final class TreeSnapshot: Model, Content {
    static let schema = "tree_snapshots"

    @ID
    var id: UUID?

    @Parent(key: "creator_id")
    var creator: User

    @Parent(key: "tree_id")
    var tree: Tree

    @Field(key: "snapshot_data")
    var snapshotData: Tree.Snapshot

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, treeID: UUID, createdAt: Date? = Date.now) {
        self.id = id
        $tree.id = treeID
        self.createdAt = createdAt
    }

    struct DTO {}
}
