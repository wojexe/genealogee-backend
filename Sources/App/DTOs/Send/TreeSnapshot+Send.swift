import Fluent
import Vapor

extension TreeSnapshot.DTO {
    struct Send: Content {
        let id: UUID
        let creatorID: UUID
        let treeID: UUID
        let snapshotData: Tree.DTO.Snapshot
        let createdAt: Date

        init(_ snapshot: TreeSnapshot, on db: Database) throws {
            id = try snapshot.requireID()
            creatorID = snapshot.$creator.id
            treeID = snapshot.$tree.id
            snapshotData = snapshot.snapshotData
            createdAt = snapshot.createdAt!
        }
    }
}
