import Fluent

struct CreateTree: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("trees")
            .id()
            .field("creator_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("name", .custom("varchar(64)"), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("trees")
            .delete()
    }
}
