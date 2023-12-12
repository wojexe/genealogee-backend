import Fluent
import Vapor

final class Family: Model, Content {
    static let schema = "families"

    @ID
    var id: UUID?

    @Parent(key: "tree_id")
    var tree: Tree

    @Siblings(through: ParentLink.self, from: \.$id.$family, to: \.$id.$person)
    var parents: [Person]

    @Siblings(through: ChildLink.self, from: \.$id.$family, to: \.$id.$person)
    var children: [Person]

    init() {}

    init(id: UUID? = nil, treeID: UUID) {
        self.id = id
        self.$tree.id = treeID
    }
}
