import Fluent
import Vapor

final class Person: Model, Content {
    static let schema = "people"

    @ID
    var id: UUID?

    @Parent(key: "creator_id")
    var creator: User

    @Parent(key: "tree_id")
    var tree: Tree

    @Field(key: "given_names")
    var givenNames: String

    @Field(key: "family_name")
    var familyName: String

    @OptionalField(key: "birth_name")
    var birthName: String?

    @Group(key: "date_of")
    var dateOf: Dates

    /// The `family` field is a `[Family]`, since we might allow to
    /// add the same person multiple times in the tree.
    @Siblings(through: ParentLink.self, from: \.$id.$person, to: \.$id.$family)
    var family: [Family]

    /// The `parentFamily` field is a `[Family]`, since we might allow to
    /// add the same person multiple times in the tree.
    @Siblings(through: ChildLink.self, from: \.$id.$person, to: \.$id.$family)
    var parentFamily: [Family]

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() {}

    init(id: UUID? = nil,
         creatorID: UUID,
         treeID: UUID,
         givenNames: String,
         familyName: String,
         birthName: String? = nil,
         dateOf: Dates)
    {
        self.id = id
        $creator.id = creatorID
        $tree.id = treeID
        self.givenNames = givenNames
        self.familyName = familyName
        self.birthName = birthName
        self.dateOf = dateOf
    }

    /// Delete the person along with all of the referencing entities (families, thus descendants)
    func nuke(on db: Database) async throws {}
}

final class Dates: Fields, Content {
    @TimestampProperty<Person, DefaultTimestampFormat>(key: "birth", on: .none)
    var birth: Date?

    @OptionalField(key: "birth_custom")
    var birthCustom: String?

    @TimestampProperty<Person, DefaultTimestampFormat>(key: "death", on: .none)
    var death: Date?

    @OptionalField(key: "death_custom")
    var deathCustom: String?

    init() {}

    init(birth: Date?, birthCustom: String? = nil, death: Date?, deathCustom: String? = nil) {
        self.birth = birth
        self.birthCustom = birthCustom
        self.death = death
        self.deathCustom = deathCustom
    }

    func birthString() -> String? {
        birth?.formatted() ?? birthCustom
    }

    func deathString() -> String? {
        death?.formatted() ?? deathCustom
    }
}

extension Person: Validatable {
    static func validations(_ val: inout Validations) {
        val.add("treeID", as: UUID.self, is: .valid)
        val.add("givenNames", as: String.self, is: .count(...128))
        val.add("familyName", as: String.self, is: .count(...128))
        val.add("birthName", as: String?.self, is: .nil || .count(...128), required: false)

        val.add("dateOf") { val in
            val.add("birth", as: Date?.self, is: .valid, required: false)
            val.add("birthCustom", as: String?.self, is: .nil || .count(...128), required: false)
            val.add("death", as: Date?.self, is: .valid, required: false)
            val.add("deathCustom", as: String?.self, is: .nil || .count(...128), required: false)
        }
    }
}
