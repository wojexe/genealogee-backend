import Fluent

struct CreatePerson: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("people")
            .id()
            .field("creator_id", .uuid, .required, .references("users", "id"))
            .field("parent_family_id", .uuid, .references("families", "id"))
            .field("given_names", .custom("varchar(128)"), .required)
            .field("family_name", .custom("varchar(128)"), .required)
            .field("birth_name", .string)
            .field("date_of_birth", .datetime)
            .field("date_of_death", .datetime)
            .field("date_of_birth_custom", .custom("varchar(128)"))
            .field("date_of_death_custom", .custom("varchar(128)"))
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("people").delete()
    }
}
