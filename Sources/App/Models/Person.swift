import Fluent
import Vapor

final class Person: Model, Content {
    static let schema = "people"

    @ID
    var id: UUID?

    @Parent(key: "creator_id")
    var creator: User

    @OptionalParent(key: "parent_family_id")
    var parentFamily: Family?

    @Field(key: "given_names")
    var givenNames: String

    @Field(key: "family_name")
    var familyName: String

    @OptionalField(key: "birth_name")
    var birthName: String?

    @Group(key: "date_of")
    var dateOf: Dates

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: UUID? = nil,
         creatorID: UUID,
         givenNames: String,
         familyName: String,
         birthName: String? = nil,
         dateOf: Dates) {
        self.id = id
        self.$creator.id = creatorID
        self.givenNames = givenNames
        self.familyName = familyName
        self.birthName = birthName
        self.dateOf = dateOf
    }
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

    init() { }

    init(birth: Date?, birthCustom: String? = nil, death: Date?, deathCustom: String? = nil) {
        self.birth = birth
        self.birthCustom = birthCustom
        self.death = death
        self.deathCustom = deathCustom
    }

    func birthString() -> String? {
        self.birth?.formatted() ?? self.birthCustom
    }

    func deathString() -> String? {
        self.death?.formatted() ?? self.deathCustom
    }
}

extension Person: Validatable {
    static func validations(_ v: inout Validations) {
        v.add("givenNames", as: String.self, is: .count(...128))
        v.add("familyName", as: String.self, is: .count(...128))
        v.add("birthName", as: String?.self, is: .nil || .count(...128), required: false)

        v.add("date_of") { d in
            d.add("birth", as: Date?.self, is: .valid, required: false)
            d.add("birthCustom", as: String?.self, is: .nil || .count(...128), required: false)
            d.add("death", as: Date?.self, is: .valid, required: false)
            d.add("deathCustom", as: String?.self, is: .nil || .count(...128), required: false)
        }
    }
}
