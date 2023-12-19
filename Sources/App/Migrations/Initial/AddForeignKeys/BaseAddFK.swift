import Fluent
import FluentSQL

protocol AddFKAsyncMigration: AsyncMigration {
    var MIGRATIONS: [String] { get }
    var REVERTS: [String] { get }
}

extension AddFKAsyncMigration {
    func prepare(on database: Database) async throws {
        let database = database as! SQLDatabase

        for migration in MIGRATIONS {
            try await database.raw(.init(migration)).run()
        }
    }

    func revert(on database: Database) async throws {
        let database = database as! SQLDatabase

        for revert in REVERTS {
            try await database.raw(.init(revert)).run()
        }
    }
}
