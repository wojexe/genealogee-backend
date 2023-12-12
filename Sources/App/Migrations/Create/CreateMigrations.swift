import Fluent

enum CreateMigrations {
    static func all() -> [AsyncMigration] {
        [
            CreateUser(),
            CreatePerson(),
            CreateTree(),
            CreateFamily(),
            CreateFamilyLink(),
            CreateChildLink(),
        ]
    }
}
