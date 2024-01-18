import Fluent
import Vapor

extension Tree.DTO {
    struct Created: Content {
        var id: UUID
        var name: String
        var rootFamilyID: UUID?

        init(_ tree: Tree) throws {
            id = try tree.requireID()
            name = tree.name
            rootFamilyID = tree.rootFamilyID
        }
    }
}
