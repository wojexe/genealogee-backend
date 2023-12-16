import Fluent
import Vapor

extension Tree {
    convenience init(from req: Create, creatorID: UUID) throws {
        self.init(creatorID: creatorID,
                  rootFamilyID: req.rootFamilyID,
                  name: req.name)
    }

    struct Create: Content {
        var name: String
        var rootFamilyID: UUID?
    }
}
