import Fluent

struct CreateFamilyLink: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("family_links")
            .field("family_id", .uuid, .required)
            .field("person_id", .uuid, .required)
            .unique(on: "family_id", "person_id")
            .constraint(.custom("PRIMARY KEY (family_id, person_id)"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("family_links").delete()
    }
}
