import Fluent

final class CreateMigrations {
    static func all() -> [AsyncMigration] {
        return [
            CreateUser(),
            CreatePerson(),
            CreateTree(),
            CreateFamily(),
            CreateFamilyLink(),
            CreateChildLink()
        ]
    }
}
