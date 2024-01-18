import Fluent
import Vapor

final class TreeSnapshot: Model {
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

    init(id: UUID? = nil,
         creatorID: UUID,
         treeID: UUID,
         snapshotData: Tree.Snapshot,
         createdAt: Date? = Date.now)
    {
        self.id = id
        $creator.id = creatorID
        $tree.id = treeID
        self.snapshotData = snapshotData
        self.createdAt = createdAt
    }

    struct DTO {}
}
