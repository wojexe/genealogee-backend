import Fluent
import Vapor

extension TreeService {
    func restore(treeID: UUID, snapshotID: UUID, on db: Database? = nil) async throws -> Tree {
        req.logger.info("Restoring tree \(treeID) from snapshot \(snapshotID)")
        defer { req.logger.info("Tree \(treeID) restored from snapshot \(snapshotID)") }

        let db = db ?? req.db

        let tree = try await req
            .trees
            .get(id: treeID)

        let snapshot = try await req
            .treeSnapshots
            .get(by: .snapshotID(snapshotID))

        let snapshotData = snapshot.snapshotData

        try await tree.restore(from: snapshotData, on: db)

        return try await req.trees.get(id: treeID) // Reload tree
    }
}
