import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

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
    case .development:
        app.sessions.use(.memory)
        app.logger.logLevel = .debug

    default:
        app.sessions.use(.fluent)
        app.logger.logLevel = .info
    }

    app.trees.use { DatabaseTreeRepository(req: $0) }

    try routes(app)
}
