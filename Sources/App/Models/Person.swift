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

    @Parent(key: "family_id")
    var family: Family

    @OptionalParent(key: "parent_family_id")
    var parentFamily: Family?

    init() {}

    init(id: UUID? = nil,
         creatorID: UUID,
         treeID: UUID,
         familyID: UUID,
         parentFamilyID: UUID? = nil,
         givenNames: String,
         familyName: String,
         birthName: String? = nil,
         dateOf: Dates)
    {
        self.id = id
        $creator.id = creatorID
        $tree.id = treeID
        $family.id = familyID
        $parentFamily.id = parentFamilyID
        self.givenNames = givenNames
        self.familyName = familyName
        self.birthName = birthName
        self.dateOf = dateOf
    }

    func nuke(withFamily: Bool = false, on db: Database) async throws {
        try await db.transaction { db in
            let family = try await self.$family.get(on: db)
            let parents = try await family.$parents.get(on: db)

            if withFamily || parents.count == 1 {
                try await family.nuke(on: db)
            } else {
                try await self.delete(on: db)
            }
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
