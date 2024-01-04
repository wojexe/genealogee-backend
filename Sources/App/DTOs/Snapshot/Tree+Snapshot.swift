import Fluent
import Vapor

extension Tree {
    struct Snapshot: Codable {
        let id: UUID
        let sourceTreeID: UUID
        let name: String
        let people: [Person.Snapshot]
        let families: [Family.Snapshot]
        let rootFamilyID: UUID
    }
}
