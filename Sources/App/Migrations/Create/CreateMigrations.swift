import Fluent

final class CreateMigrations {
    static func all() -> Array<AsyncMigration> {
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
