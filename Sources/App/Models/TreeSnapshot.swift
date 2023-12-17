import Fluent
import Vapor

final class TreeSnapshot: Model, Content {
    static let schema = "tree_versions"

    @ID
    var id: UUID?

    @Parent(key: "tree_id")
    var tree: Tree

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, treeID: UUID, createdAt: Date? = Date.now) {
        self.id = id
        $tree.id = treeID
        self.createdAt = createdAt
    }
}
