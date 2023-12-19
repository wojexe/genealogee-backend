// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "genealogy_backend",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.88.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        // 🪶 Fluent driver for PostgreSQL.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // 🪶 Fluent driver for SQLite.
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.6.0"),
        // 🥞 A powerful SQL query builder.
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.0.0"),
        // Fake data generator for mocks
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.0.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "SQLKit", package: "sql-kit"),
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),

            // Workaround for https://github.com/apple/swift-package-manager/issues/6940
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "Fluent"),
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "SQLKit", package: "sql-kit"),
            .product(name: "Fakery", package: "Fakery"),
        ]),
    ]
)
