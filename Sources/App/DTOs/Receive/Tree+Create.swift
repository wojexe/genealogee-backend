import Fluent
import Vapor

extension Tree {
    convenience init(from req: Create, creatorID: UUID) throws {
        self.init(creatorID: creatorID,
                  name: req.name,
                  rootFamilyID: req.rootFamilyID)
    }

    struct Create: Content {
        var name: String
        var rootFamilyID: UUID?
    }
}
