import Fluent
import SQLKit

struct CreateFamily: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("families")
            .id()
            .field("tree_id", .uuid, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("families")
            .delete()
    }
}
