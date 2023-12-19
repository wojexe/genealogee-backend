import Fluent

enum ForeignKeyMigrations {
    static func all() -> [AsyncMigration] {
        [
            AddFKPerson(),
            AddFKFamily(),
            AddFKTree(),
            AddFKParentLink(),
            AddFKChildLink()
        ]
    }
}
