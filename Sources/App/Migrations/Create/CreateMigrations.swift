import Fluent

enum CreateMigrations {
    static func all() -> [AsyncMigration] {
        [
            CreateUser(),
            CreateTree(),
            CreatePerson(),
            CreateFamily(),
            CreateParentLink(),
            CreateChildLink(),
            AddRootFamilyID(),
            CreateTreeSnapshot(),
        ]
    }
}
