import Fluent
import Vapor

final class FamilyAndPerson<Model: FluentKit.Model>: Fields, Hashable {
    @ParentProperty<Model, Family>(key: "family_id")
    var family: Family

    @ParentProperty<Model, Person>(key: "person_id")
    var person: Person

    init() {}

    init(familyID: UUID, personID: UUID) {
        $family.id = familyID
        $person.id = personID
    }

    static func == (lhs: FamilyAndPerson, rhs: FamilyAndPerson) -> Bool {
        lhs.$family.id == rhs.$family.id &&
            lhs.$person.id == rhs.$person.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine($family.id)
        hasher.combine($person.id)
    }
}
