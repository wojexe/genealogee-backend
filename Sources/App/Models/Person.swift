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

    func nuke(on db: Database) async throws {
        try await db.transaction { db in
            let families = try await self.$family.get(on: db)

            for family in families {
                // The deleted person is a parent of the family
                let parents = try await family.$parents.get(on: db)

                // So we either nuke it, or detach the person from the family
                if parents.count == 1 {
                    try await family.nuke(on: db)
                } else {
                    try await family.$parents.detach(self, on: db)
                }
            }

            try await self.delete(on: db)
        }
    }

    struct DTO {}
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

    struct DTO {}
}
