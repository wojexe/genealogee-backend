import Fluent
import Vapor

extension Tree.DTO {
    struct Snapshot: Codable {
        let sourceTreeID: UUID
        let name: String
        let people: [Person.DTO.Snapshot]
        let families: [Family.DTO.Snapshot]
        let rootFamilyID: UUID

        init(from tree: Tree, on db: Database) async throws {
            let treeID = try tree.requireID()

            let tree = try await Tree.query(on: db)
                .filter(\.$id == treeID)
                .with(\.$people)
                .with(\.$families)
                .first() ?! Abort(.internalServerError, reason: "Tree not found")

            sourceTreeID = try tree.requireID()
            name = tree.name
            people = try tree.people.map(Person.DTO.Snapshot.init)
            families = try await Self.snapshotFamilies(tree.families, on: db)
            rootFamilyID = try tree.rootFamilyID ?! Abort(.internalServerError, reason: "Tree has no root family")
        }

        static func snapshotFamilies(_ families: [Family], on db: Database) async throws -> [Family.DTO.Snapshot] {
            var snapshots: [Family.DTO.Snapshot] = []

            for family in families {
                let snapshot = try! await Family.DTO.Snapshot(from: family, on: db)
                snapshots.append(snapshot)
            }

            return snapshots
        }
    }
}
