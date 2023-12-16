import Fluent
import Vapor

extension Family {
    struct Created: Content {
        var ID: UUID
        var parents: [UUID]
        var children: [UUID]

        init(_ family: Family, _ db: Database) async throws {
            self.ID  = try family.requireID()
            self.parents = try await family.$parents.get(on: db).map { try $0.requireID() }
            self.children = try await family.$children.get(on: db).map { try $0.requireID() }
        }
    }
}
