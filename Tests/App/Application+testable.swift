import Fluent
import Vapor

import App

extension Application {
    public static func testable() async throws -> Application {
        let app = Application(.testing)
        try await configure(app)

        try! await app.autoRevert()
        try! await app.autoMigrate()

        return app
    }
}
