import Fluent
import Vapor

final class ChildLink: Model {
    static let schema = "child_links"

    @CompositeID
    var id: FamilyAndPerson<ChildLink>?

    init() { }

    init(familyID: UUID, personID: UUID) {
        self.id = .init(familyID: familyID, personID: personID)
    }
}
