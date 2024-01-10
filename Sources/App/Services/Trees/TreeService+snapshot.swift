import Fluent
import Vapor

extension TreeService {
    func snapshot(_: Tree) async throws -> TreeSnapshot.DTO.Created {
        // Make snapshot of the provided tree
        // Create new TreeSnapshot with the above data and save it to the database
        throw Abort(.notImplemented)
    }
}
