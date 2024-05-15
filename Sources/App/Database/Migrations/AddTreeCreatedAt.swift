import Fluent
import PostgresKit
import SQLiteKit
import SQLKit

struct AddTreeCreatedAt: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.transaction { database in
            try await database.schema(Tree.schema)
                .field("created_at", .datetime)
                .update()

            try await Backfill
                .TreeCreatedAt(database)
                .perform()

            switch database {
            case let db as PostgresDatabase:
                let db = db as! any SQLDatabase

                try await db.alter(table: Tree.schema)
                    .modifyNullability(of: "created_at", isNullable: false)
                    .run()
            default:
                fatalError("Database is not PostgreSQL")
            }
        }
    }

    func revert(on database: Database) async throws {
        // No need to run a revert, since migration removes the column

        try await database.schema(Tree.schema)
            .deleteField("created_at")
            .update()
    }
}
