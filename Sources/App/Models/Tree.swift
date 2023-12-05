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

    init() { }

    init(id: UUID? = nil, creatorID: UUID, name: String, rootFamilyID: UUID? = nil, families: [Family] = []) {
        self.id = id
        self.$creator.id = creatorID
        self.name = name
        self.rootFamilyID = rootFamilyID
        self.families = families
    }
}

extension Tree: Validatable {
    static func validations(_ d: inout Validations) {
        d.add("name", as: String.self, is: .count(...64))
        d.add("rootFamily", as: UUID.self, required: false)
    }
}
