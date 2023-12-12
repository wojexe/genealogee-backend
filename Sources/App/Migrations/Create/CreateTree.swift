import Fluent

struct CreateTree: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("trees")
            .id()
            .field("creator_id", .uuid, .required, .references("users", "id"))
            .field("name", .custom("varchar(64)"), .required)
            .field("root_family_id", .uuid, .references("families", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("trees").delete()
    }
}
