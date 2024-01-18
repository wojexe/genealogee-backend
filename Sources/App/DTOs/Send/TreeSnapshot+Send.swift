import Fluent
import Vapor

extension TreeSnapshot.DTO {
    struct Send: Content {
        let id: UUID
        let creatorID: UUID
        let treeID: UUID
        let snapshotData: Tree.DTO.Snapshot
        let createdAt: Date

        init(_ snapshot: TreeSnapshot, on db: Database) async throws {
            id = try snapshot.requireID()
            creatorID = try await snapshot.$creator.get(on: db).requireID()
            treeID = try await snapshot.$tree.get(on: db).requireID()
            snapshotData = snapshot.snapshotData
            createdAt = snapshot.createdAt!
        }
    }
}
