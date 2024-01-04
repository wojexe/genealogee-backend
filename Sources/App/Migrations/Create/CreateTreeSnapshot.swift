import Fluent

struct CreateTreeSnapshot: AsyncMigration {
    func prepare(on db: Database) async throws {
        try await db.schema("tree_snapshots")
            .id()
            .field("creator_id", .uuid, .required)
            .field("tree_id", .uuid, .required)
            .field("snapshot", .json, .required)
            .field("created_at", .datetime, .required)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("tree_snapshots").delete()
    }
}
