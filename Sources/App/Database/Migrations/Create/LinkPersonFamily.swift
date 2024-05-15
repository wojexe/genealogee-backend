import Fluent

struct LinkPersonFamily: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("people")
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("people")
            .deleteField("family_id")
            .deleteField("parent_family_id")
            .update()
    }
}
