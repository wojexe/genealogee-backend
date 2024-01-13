import Fluent
import Vapor

extension Family {
    struct Snapshot: Codable {
        let sourceFamilyID: UUID
        let parentIDs: [UUID]
        let childIDs: [UUID]

        init(from family: Family, on db: Database) async throws {
            sourceFamilyID = try family.requireID()
            parentIDs = try await family.$parents.get(on: db).map { try $0.requireID() }
            childIDs = try await family.$children.get(on: db).map { try $0.requireID() }
        }
    }
}
