import Fluent
import Vapor

extension Family {
    struct Created: Content {
        var ID: UUID
        var parents: [UUID]
        var children: [UUID]

        init(_ family: Family, _ db: Database) async throws {
            ID = try family.requireID()
            parents = try await family.$parents.get(on: db).map { try $0.requireID() }
            children = try await family.$children.get(on: db).map { try $0.requireID() }
        }
    }
}
