import Fluent
import Vapor

extension Family {
    struct Snapshot: Codable {
        let sourceFamilyID: UUID
        let parentIDs: [UUID]
        let childIDs: [UUID]
    }
}
