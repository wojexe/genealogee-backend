import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
    
    app.databases.middleware.use(UserMiddleware())
    
    app.migrations.add(User.CreateUser())
    app.migrations.add(SessionRecord.migration)
    
    // Add CORS middleware for prod
    app.middleware.use(app.sessions.middleware)
    app.middleware.use(User.sessionAuthenticator()) // Session cookies
    
    app.passwords.use(.bcrypt)
    
    switch app.environment {
    case .development:
        app.sessions.use(.memory)
        
    default:
        app.sessions.use(.fluent)
    }
    
    try routes(app)
}
