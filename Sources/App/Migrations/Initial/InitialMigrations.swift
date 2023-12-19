import Fluent
import Vapor

enum InitialMigrations {
    static func all(_ env: Environment) -> [AsyncMigration] {
        switch env {
            case .production:
                CreateMigrations.all() + ForeignKeyMigrations.all()
            default:
                // TODO: Rewrite FK migrations, to work with SQLite
                CreateMigrations.all()
        }
    }
}
