import Fluent
import Vapor

enum TreeServiceRestoreUsing: Decodable {
    case treeID(UUID)
    case snapshotID(UUID)
    case snapshotData(Tree.Snapshot)
}

extension TreeService {
    func restore(treeID: UUID, snapshotID: UUID, on db: Database? = nil) async throws -> Tree {
        let db = db ?? req.db

        let tree = try await req
            .trees
            .get(id: treeID)

        let snapshot = try await req
            .treeSnapshots
            .get(by: .snapshotID(snapshotID))

        let snapshotData = snapshot.snapshotData

        try await tree.restore(from: snapshotData, on: db)

        return tree
    }
}
