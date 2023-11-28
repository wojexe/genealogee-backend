import Fluent
import Vapor

final class Person: Model, Content {
    static let schema = "people"
    
    @ID
    var id: UUID?
    
    @Parent(key: "creator_id")
    var creator: User
    
    @Field(key: "given_names")
    var givenNames: String
    
    @Field(key: "family_name")
    var familyName: String
    
    @OptionalField(key: "birth_name")
    var birthName: String?
    
    @Group(key: "date_of")
    var date_of: Dates
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, givenNames: String, familyName: String, birthName: String? = nil, date_of: Dates) {
        self.id = id
        self.givenNames = givenNames
        self.familyName = familyName
        self.birthName = birthName
        self.date_of = date_of
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
        
        v.add("date_of") { date_of in
            date_of.add("birth", as: Date?.self, is: .valid, required: false)
            date_of.add("birthCustom", as: String?.self, is: .nil || .count(...128), required: false)
            date_of.add("death", as: Date?.self, is: .valid, required: false)
            date_of.add("deathCustom", as: String?.self, is: .nil || .count(...128), required: false)
        }
    }
}
