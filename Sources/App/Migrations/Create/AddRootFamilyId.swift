import Fluent
import FluentSQLiteDriver

struct AddRootFamilyID: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("trees")
            .field("root_family_id", .uuid, .references("families", "id", onDelete: .setNull))
            .update()
    }

    func revert(on database: Database) async throws {
        // For SQLite, we need to drop the column manually
        if let driver = database as? SQLiteDatabase {
            try await driver
                .sql()
                .alter(table: Tree.schema)
                .dropColumn("root_family_id")
                .run()

            return
        }

        try await database.schema("trees")
            .deleteField("root_family_id")
            .update()
    }
}
