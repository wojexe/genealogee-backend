import Fluent

struct CreateFamily: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("families")
            .id()
            .field("tree_id", .uuid, .required, .references("trees", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("families").delete()
    }
}
