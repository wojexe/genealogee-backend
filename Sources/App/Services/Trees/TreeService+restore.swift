import Fluent
import Vapor

extension TreeService {
    func restore(snapshotID: UUID) async throws -> Tree.Created {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        let snapshot = try await req
            .treeSnapshots
            .get(by: .snapshotID(snapshotID))

        let snapshotData = snapshot.snapshotData

        let tree = Tree(creatorID: userID, rootFamilyID: nil, name: snapshotData.name)

        try await req.db.transaction { db in
            try await tree.save(on: db)

            let treeID = try tree.requireID()

            // TODO: Extract errors to an error type
            guard let people = try? await restorePeople(snapshotData.people, treeID: treeID, on: db) else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot")
            }

            guard let families = try? await restoreFamilies(snapshotData.families, people, treeID: treeID, on: db) else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot")
            }

            guard let rootFamily = families[snapshotData.rootFamilyID] else {
                throw Abort(.internalServerError, reason: "Error while restoring snapshot")
            }

            let rootFamilyID = try rootFamily.requireID()

            tree.$rootFamilyID.value = rootFamilyID

            try await tree.update(on: db)
        }

        return try Tree.Created(tree)
    }

    /// Retuns a mapping of source IDs to the restored people objects
    private func restorePeople(_ people: [Person.Snapshot],
                               treeID: UUID,
                               on db: Database) async throws -> [UUID: Person]
    {
        let creatorID = try req.auth.require(User.self).requireID()

        let people = people.reduce(into: [:]) { mapping, personSnapshot in
            mapping[personSnapshot.sourcePersonID] =
                Person(from: personSnapshot, treeID: treeID, creatorID: creatorID)
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
        let creatorID = try req.auth.require(User.self).requireID()

        let families = familySnapshots.reduce(into: [:]) { mapping, familySnapshot in
            mapping[familySnapshot.sourceFamilyID] = Family(creatorID: creatorID, treeID: treeID)
        }

        try await families.map(\.value).create(on: db)

        var childLinks: [ChildLink] = []
        var parentLinks: [ParentLink] = []

        for familySnapshot in familySnapshots {
            let familyID = try families[familySnapshot.sourceFamilyID]!.requireID()

            childLinks += try familySnapshot.childIDs.map { try .init(familyID: familyID, personID: people[$0]!.requireID()) }
            parentLinks += try familySnapshot.parentIDs.map { try .init(familyID: familyID, personID: people[$0]!.requireID()) }
        }

        try await childLinks.create(on: db)
        try await parentLinks.create(on: db)

        return families
    }
}
