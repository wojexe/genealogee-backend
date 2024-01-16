import Fluent
import Vapor

extension TreeService {
    func createSnapshot(_ treeID: UUID) async throws -> TreeSnapshot.DTO.Send {
        let user = try req.auth.require(User.self)

        let tree = try await req.trees.get(id: treeID)

        let snapshotData = try await tree.snapshot(on: req.db)

        let treeSnapshot = try TreeSnapshot(
            creatorID: user.requireID(),
            treeID: tree.requireID(),
            snapshotData: snapshotData
        )

        try await treeSnapshot.save(on: req.db)

        return try await .init(treeSnapshot, req.db)
    }
}
