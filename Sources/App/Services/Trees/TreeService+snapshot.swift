import Fluent
import Vapor

extension TreeService {
    func snapshot(_: Tree) async throws -> TreeSnapshot {
        throw Abort(.notImplemented)
    }
}
