import Fluent
import SQLKit

struct CreateFamily: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("families")
            .id()
            .field("creator_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("tree_id", .uuid, .required, .references("trees", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("families")
            .delete()
    }
}
