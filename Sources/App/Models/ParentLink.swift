import Fluent
import Vapor

final class ParentLink: Model {
    static let schema = "parent_links"
    
    @CompositeID
    var id: FamilyAndPerson<ParentLink>?
    
    init() { }
    
    init(familyID: UUID, personID: UUID) {
        self.id = .init(familyID: familyID, personID: personID)
    }
}
