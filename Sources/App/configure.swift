import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) async throws {
    try configureDatabase(app)

    app.databases.middleware.use(UserMiddleware())

    app.migrations.add(CreateMigrations.all())

    app.migrations.add(SessionRecord.migration)

    // json date decoder

    let jsDateFormatter = DateFormatter()
    jsDateFormatter.calendar = Calendar(identifier: .iso8601)
    jsDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(jsDateFormatter)

    ContentConfiguration.global.use(decoder: decoder, for: .json)

    // json fin

    // Add CORS middleware for prod

    app.middleware.use(app.sessions.middleware)
    app.middleware.use(User.sessionAuthenticator())

    app.passwords.use(.bcrypt)

    switch app.environment {
    case .development: fallthrough
    case .testing:
        app.sessions.use(.memory)
        app.logger.logLevel = .trace

    default:
        app.sessions.use(.fluent)
        app.logger.logLevel = .info
    }

    app.trees.use { DatabaseTreeRepository(req: $0) }
    app.people.use { DatabasePersonRepository(req: $0) }
    app.families.use { DatabaseFamilyRepository(req: $0) }
    app.treeSnapshots.use { DatabaseTreeSnapshotRepository(req: $0) }

    try routes(app)
}

private func configureDatabase(_ app: Application) throws {
    let postgresURL = Environment.get("POSTGRES_URL")

    switch app.environment {
    case .production:
        try app.databases.use(.postgres(url: postgresURL!), as: .psql)
    case .testing:
        app.databases.use(.sqlite(.memory), as: .sqlite)
    default:
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }
}
