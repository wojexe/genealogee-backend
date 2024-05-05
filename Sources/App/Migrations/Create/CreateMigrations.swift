import Fluent

enum CreateMigrations {
    static func all() -> [AsyncMigration] {
        [
            CreateUser(),
            CreateTree(),
            CreateFamily(),
            CreatePerson(),
            AddRootFamilyID(),
            CreateTreeSnapshot(),
        ]
    }
}
