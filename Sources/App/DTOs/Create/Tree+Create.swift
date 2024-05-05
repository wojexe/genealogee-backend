import Fluent
import Vapor

extension Tree {
    convenience init(from req: DTO.Create, creatorID: UUID) throws {
        self.init(creatorID: creatorID, name: req.name)
    }
}

extension Tree.DTO {
    struct Create: Content, Validatable {
        var name: String

        static func validations(_ val: inout Validations) {
            val.add("name", as: String.self, is: .count(...128))
            val.add("rootFamilyID", as: UUID.self, required: false)
        }
    }
}
