import Fluent
import Vapor

final class Tree: Model, Content {
    static let schema = "trees"

    @ID
    var id: UUID?

    @Parent(key: "creator_id")
    var creator: User

    @Field(key: "name")
    var name: String

    @OptionalField(key: "root_family_id")
    var rootFamilyID: UUID?

    @Children(for: \.$tree)
    var families: [Family]

    @Children(for: \.$tree)
    var people: [Person]

    @Children(for: \.$tree)
    var snapshots: [TreeSnapshot]

    init() {}

    init(id: UUID? = nil,
         creatorID: UUID,
         rootFamilyID: UUID? = nil,
         name: String)
    {
        self.id = id
        $creator.id = creatorID
        self.name = name
        self.rootFamilyID = rootFamilyID
    }

    // Foreign key constraints ensure that all related data is deleted
    func nuke(on db: Database) async throws {
        try await delete(on: db)
    }

    func snapshot(on db: Database) async throws -> Tree.DTO.Snapshot {
        try await Tree.DTO.Snapshot(from: self, on: db)
    }

    func restore(from snapshot: Tree.DTO.Snapshot, on db: Database) async throws {
        let treeID = try requireID()

        try await db.transaction { db in
            self.$name.value = snapshot.name

            try await self.$people.query(on: db).delete()
            try await self.$families.query(on: db).delete()

            guard let families = try? await self.restoreFamilies(snapshot.families, treeID: treeID, on: db) else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot - families")
            }

            guard let people = try? await self.restorePeople(snapshot.people, families, treeID: treeID, on: db) else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot - people")
            }

            guard let rootFamily = families[snapshot.rootFamilyID] else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot")
            }

            self.$people.value = people.map(\.value)
            self.$families.value = families.map(\.value)
            self.$rootFamilyID.value = try rootFamily.requireID()

            // TODO: Make sure people and families have correct relations set to avoid refetching them

            try await self.update(on: db)
        }
    }

    /// Returns a mapping of source IDs to the restored family objects
    private func restoreFamilies(_ familySnapshots: [Family.DTO.Snapshot],
                                 treeID: UUID,
                                 on db: Database) async throws -> [UUID: Family]
    {
        let families = familySnapshots.reduce(into: [:]) { mapping, familySnapshot in
            mapping[familySnapshot.sourceFamilyID] = Family(creatorID: self.$creator.id, treeID: treeID)
        }

        try await families.map(\.value).create(on: db)

        return families
    }

    /// Retuns a mapping of source IDs to the restored people objects
    private func restorePeople(_ people: [Person.DTO.Snapshot],
                               _ families: [UUID: Family],
                               treeID: UUID,
                               on db: Database) async throws -> [UUID: Person]
    {
        let people: [UUID: Person] = try people.reduce(into: [:]) { mapping, personSnapshot in
            let familyID = try families[personSnapshot.sourceFamilyID]!.requireID()
            let parentFamilyID = try personSnapshot.sourceParentFamilyID != nil
                ? families[personSnapshot.sourceParentFamilyID!]!.requireID()
                : nil

            mapping[personSnapshot.sourcePersonID] =
                Person(from: personSnapshot,
                       treeID: treeID,
                       creatorID: self.$creator.id,
                       familyID: familyID,
                       parentFamilyID: parentFamilyID)
        }

        try await people.map(\.value).create(on: db)

        return people
    }

    struct DTO {}
}
