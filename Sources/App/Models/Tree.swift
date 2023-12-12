import Fluent
import Vapor

final class Tree: Model, Content {
    static let schema = "trees"

    @ID
    var id: UUID?

    @Parent(key: "creator_id")
    var creator: User

    @Field(key: "name")
    var name: String

    @OptionalField(key: "root_family_id")
    var rootFamilyID: UUID?

    @Children(for: \.$tree)
    var families: [Family]

    @Children(for: \.$tree)
    var people: [Person]

    init() {}

    init(id: UUID? = nil, creatorID: UUID, name: String, rootFamilyID: UUID? = nil) {
        self.id = id
        $creator.id = creatorID
        self.name = name
        self.rootFamilyID = rootFamilyID
    }
}

extension Tree: Validatable {
    static func validations(_ d: inout Validations) {
        d.add("name", as: String.self, is: .count(...64))
        d.add("rootFamily", as: UUID.self, required: false)
    }
}