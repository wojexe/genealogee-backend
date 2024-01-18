import Fluent
import Vapor

extension TreeService {
    func delete(_ treeID: UUID) async throws {
        let tree = try await req.trees.get(id: treeID)

        try await tree.nuke(on: req.db)
    }
}
