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

    func snapshot(on db: Database) async throws -> Tree.Snapshot {
        try await Tree.Snapshot(from: self, on: db)
    }

    func restore(from snapshot: Tree.Snapshot, on db: Database) async throws {
        let treeID = try requireID()

        try await db.transaction { db in
            self.$name.value = snapshot.name

            try await Family.query(on: db).filter(\.$tree.$id == treeID).delete()
            try await Person.query(on: db).filter(\.$tree.$id == treeID).delete()

            guard let people = try? await self.restorePeople(snapshot.people, treeID: treeID, on: db) else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot - people")
            }

            guard let families = try? await self.restoreFamilies(snapshot.families, people, treeID: treeID, on: db) else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot - families")
            }

            guard let rootFamily = families[snapshot.rootFamilyID] else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot")
            }

            self.$people.value = people.map(\.value)
            self.$families.value = families.map(\.value)
            self.$rootFamilyID.value = try rootFamily.requireID()

            try await self.update(on: db)
        }
    }

    /// Retuns a mapping of source IDs to the restored people objects
    private func restorePeople(_ people: [Person.Snapshot],
                               treeID: UUID,
                               on db: Database) async throws -> [UUID: Person]
    {
        let people = people.reduce(into: [:]) { mapping, personSnapshot in
            mapping[personSnapshot.sourcePersonID] =
                Person(from: personSnapshot, treeID: treeID, creatorID: self.$creator.id)
        }

        try await people.map(\.value).create(on: db)

        return people
    }

    /// Returns a mapping of source IDs to the restored family objects
    private func restoreFamilies(_ familySnapshots: [Family.Snapshot],
                                 _ people: [UUID: Person],
                                 treeID: UUID,
                                 on db: Database) async throws -> [UUID: Family]
    {
        let families = familySnapshots.reduce(into: [:]) { mapping, familySnapshot in
            mapping[familySnapshot.sourceFamilyID] = Family(creatorID: self.$creator.id, treeID: treeID)
        }

        try await families.map(\.value).create(on: db)

        var childLinks: [ChildLink] = []
        var parentLinks: [ParentLink] = []

        for familySnapshot in familySnapshots {
            let familyID = try families[familySnapshot.sourceFamilyID]!.requireID()

            childLinks += try familySnapshot.childIDs.map { childID in
                try .init(familyID: familyID, personID: people[childID]!.requireID())
            }

            parentLinks += try familySnapshot.parentIDs.map { parentID in
                try .init(familyID: familyID, personID: people[parentID]!.requireID())
            }
        }

        try await childLinks.create(on: db)
        try await parentLinks.create(on: db)

        return families
    }

    struct DTO {}
}

extension Tree: Validatable {
    static func validations(_ val: inout Validations) {
        val.add("name", as: String.self, is: .count(...64))
        val.add("rootFamilyID", as: UUID.self, required: false)
    }
}
