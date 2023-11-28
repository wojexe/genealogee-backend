import Fluent

struct CreatePerson: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("people")
            .id()
            .field("given_names", .string, .required)
            .field("family_name", .string, .required)
            .field("birth_name", .string)
            .field("date_of_birth", .datetime)
            .field("date_of_death", .datetime)
            .field("date_of_birth_custom", .string)
            .field("date_of_death_custom", .string)
            .field("deleted_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("people").delete()
    }
}
