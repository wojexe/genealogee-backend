import Fluent
import Vapor

extension Tree {
    struct Created: Content {
        var id: UUID
        var name: String
        var rootFamilyID: UUID?

        init(_ tree: Tree) throws {
            self.id = try tree.requireID()
            self.name = tree.name
            self.rootFamilyID = tree.rootFamilyID
        }
    }
}
