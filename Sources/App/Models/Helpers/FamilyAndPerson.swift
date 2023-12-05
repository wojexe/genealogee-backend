import Fluent
import Vapor

final class FamilyAndPerson<Model: FluentKit.Model>: Fields, Hashable {
    @ParentProperty<Model, Family>(key: "family_id")
    var family: Family

    @ParentProperty<Model, Person>(key: "person_id")
    var person: Person

    init() { }

    init(familyID: UUID, personID: UUID) {
        self.$family.id = familyID
        self.$person.id = personID
    }

    static func == (lhs: FamilyAndPerson, rhs: FamilyAndPerson) -> Bool {
        return (lhs.$family.id == rhs.$family.id &&
                lhs.$person.id == rhs.$person.id)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.$family.id)
        hasher.combine(self.$person.id)
    }
}
