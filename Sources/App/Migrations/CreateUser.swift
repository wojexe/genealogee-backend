import Fluent

extension User {
    struct CreateUser: AsyncMigration {
        let name: String = "\(CreateUser.self)"
        
        func prepare(on database: Database) async throws {
            try await database.schema("users")
                .id()
                .field("email", .string, .required)
                .field("name", .string, .required)
                .field("password_hash", .string, .required)
                .unique(on: "email")
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("users").delete()
        }
    }
}
