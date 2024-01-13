import Fluent
import Vapor

extension TreeService {
    func snapshot(_ tree: Tree) async throws -> TreeSnapshot.DTO.Created {
        let user = try req.auth.require(User.self)

        let snapshotData = try await Tree.Snapshot(from: tree, on: req.db)

        let treeSnapshot = try TreeSnapshot(
            creatorID: user.requireID(),
            treeID: tree.requireID(),
            snapshotData: snapshotData
        )

        try await treeSnapshot.save(on: req.db)

        return try await .init(treeSnapshot, req.db)
    }
}
