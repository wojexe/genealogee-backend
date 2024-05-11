import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) async throws {
    try configureDatabase(app)

    app.databases.middleware.use(UserMiddleware())

    app.migrations.add(CreateMigrations.all())

    app.migrations.add(SessionRecord.migration)

    // Ability to parse JS dates

    let jsDateFormatter = DateFormatter()
    jsDateFormatter.calendar = Calendar(identifier: .iso8601)
    jsDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(jsDateFormatter)

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(jsDateFormatter)

    ContentConfiguration.global.use(encoder: encoder, for: .json)
    ContentConfiguration.global.use(decoder: decoder, for: .json)

    // Middlewares

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .any(["https://localhost:8788","https://localhost:5173", "https://localhost:4173",
                             "https://genealogee.app"]),
        allowedMethods: [.GET, .POST, .DELETE, .PATCH, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith,
                         .userAgent, .accessControlAllowOrigin, .accessControlAllowHeaders,
                         .accessControlAllowCredentials, .accessControlAllowMethods],
        allowCredentials: true
    )

    let cors = CORSMiddleware(configuration: corsConfiguration)

    // Sessions

    let cookieDomain = app.environment == .development ? "localhost" : "genealogee.app"
    app.sessions.configuration.cookieFactory = { sessionID in
        .init(string: sessionID.string,
              maxAge: 60 * 60 * 24 * 7,
              domain: cookieDomain,
              isSecure: true,
              isHTTPOnly: false,
              sameSite: HTTPCookies.SameSitePolicy.strict)
    }

    app.middleware.use(cors, at: .beginning)

    app.middleware.use(app.sessions.middleware)
    app.middleware.use(User.sessionAuthenticator())

    app.passwords.use(.bcrypt)

    switch app.environment {
    case .development:
        app.http.server.configuration.tlsConfiguration = try .makeServerConfiguration(
            certificateChain: NIOSSLCertificate.fromPEMFile("./certs/cert.pem").map { .certificate($0) },
            privateKey: .file("./certs/key.pem")
        )

        fallthrough
    case .testing:
        app.sessions.use(.memory)

    default:
        app.sessions.use(.fluent)
    }

    app.trees.use { DatabaseTreeRepository(req: $0) }
    app.people.use { DatabasePersonRepository(req: $0) }
    app.families.use { DatabaseFamilyRepository(req: $0) }
    app.treeSnapshots.use { DatabaseTreeSnapshotRepository(req: $0) }

    try routes(app)
}

private func configureDatabase(_ app: Application) throws {
    let postgresURL = Environment.get("DATABASE_URL")

    switch app.environment {
    case .production:
        try app.databases.use(.postgres(url: postgresURL!), as: .psql)
    case .testing:
        app.databases.use(.sqlite(.memory), as: .sqlite)
    default:
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }
}
