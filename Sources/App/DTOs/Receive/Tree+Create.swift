import Fluent
import Vapor

extension Tree {
    convenience init(from req: Create, creatorID: UUID) throws {
        self.init(creatorID: creatorID, name: req.name)
    }

    struct Create: Content, Validatable {
        var name: String

        static func validations(_ validations: inout Validations) {
            validations.add("name", as: String.self, is: .count(...128))
        }
    }
}
