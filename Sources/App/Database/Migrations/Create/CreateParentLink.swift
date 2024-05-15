import Fluent

struct CreateParentLink: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("parent_links")
            .field("family_id", .uuid, .required, .references("families", "id", onDelete: .cascade))
            .field("person_id", .uuid, .required, .references("people", "id", onDelete: .cascade))
            .unique(on: "family_id", "person_id")
            .constraint(.custom("PRIMARY KEY (family_id, person_id)"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("parent_links")
            .delete()
    }
}
