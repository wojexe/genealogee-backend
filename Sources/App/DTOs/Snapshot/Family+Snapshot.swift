import Fluent
import Vapor

extension Family.DTO {
    struct Snapshot: Codable {
        let sourceFamilyID: UUID

        init(from family: Family, on db: Database) async throws {
            sourceFamilyID = try family.requireID()
        }
    }
}
