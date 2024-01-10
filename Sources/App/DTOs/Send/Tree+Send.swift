import Fluent
import Vapor

extension Tree.DTO {
    struct Send: Content {
        let id: UUID
        let creatorID: UUID
        let name: String
        let rootFamilyID: UUID?
        let families: [Family.DTO.Send]
        let people: [Person.DTO.Send]
        let snapshotIDs: [UUID]

        init(_ tree: Tree, on db: Database) async throws {
            id = try tree.requireID()
            creatorID = tree.$creator.id
            name = tree.name
            rootFamilyID = tree.rootFamilyID
            families = try await Self.gatherFamilies(from: tree, on: db)
            people = try await tree.$people.get(on: db).map { try Person.DTO.Send($0) }
            snapshotIDs = try await tree.$snapshots.get(on: db).map { try $0.requireID() }
        }

        private static func gatherFamilies(from tree: Tree, on db: Database) async throws -> [Family.DTO.Send] {
            let families = try await tree.$families.get(on: db)
            var DTOs: [Family.DTO.Send] = []

            for a_family in families {
                try await DTOs.append(Family.DTO.Send(a_family, on: db))
            }

            return DTOs
        }
    }
}
