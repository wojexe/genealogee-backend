import Fluent

struct AddRootFamilyId: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("trees")
            .field("root_family_id", .uuid, .references("families", "id", onDelete: .setNull))
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("trees")
            .deleteField("root_family_id")
            .update()
    }
}
