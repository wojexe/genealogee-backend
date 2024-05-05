import Fluent
import Vapor

extension Tree.DTO {
    struct Send: Content {
        let id: UUID
        let creatorID: UUID

        let name: String

        let people: [Person.DTO.Send]
        let families: [Family.DTO.Send]

        let rootFamilyID: UUID?

        let snapshotIDs: [UUID]

        init(_ tree: Tree, on db: Database) async throws {
            id = try tree.requireID()
            creatorID = tree.$creator.id

            name = tree.name

            people = try await Self.gatherPeople(from: tree, on: db)
            families = try await Self.gatherFamilies(from: tree, on: db)

            rootFamilyID = tree.rootFamilyID
            snapshotIDs = try await tree.$snapshots.get(on: db).map { try $0.requireID() }
        }

        private static func gatherFamilies(from tree: Tree, on db: Database) async throws -> [Family.DTO.Send] {
            let families = try await tree.$families.get(on: db)
            var DTOs: [Family.DTO.Send] = []
            DTOs.reserveCapacity(families.count)

            for family in families {
                try await DTOs.append(Family.DTO.Send(family, on: db))
            }

            return DTOs
        }

        private static func gatherPeople(from tree: Tree, on db: Database) async throws -> [Person.DTO.Send] {
            let people = try await tree.$people.get(on: db)
            var DTOs: [Person.DTO.Send] = []
            DTOs.reserveCapacity(people.count)

            for person in people {
                try await DTOs.append(Person.DTO.Send(person, on: db))
            }

            return DTOs
        }
    }
}
