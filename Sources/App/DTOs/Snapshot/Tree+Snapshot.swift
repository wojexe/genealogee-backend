import Fluent
import Vapor

extension Tree {
    struct Snapshot: Codable {
        let sourceTreeID: UUID
        let name: String
        let people: [Person.Snapshot]
        let families: [Family.Snapshot]
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
            people = try tree.people.map(Person.Snapshot.init)
            families = try await Self.snapshotFamilies(tree.families, on: db)
            rootFamilyID = try tree.rootFamilyID ?! Abort(.internalServerError, reason: "Tree has no root family")
        }

        static func snapshotFamilies(_ families: [Family], on db: Database) async throws -> [Family.Snapshot] {
            var snapshots: [Family.Snapshot] = []

            for family in families {
                let snapshot = try! await Family.Snapshot(from: family, on: db)
                snapshots.append(snapshot)
            }

            return snapshots
        }
    }
}
