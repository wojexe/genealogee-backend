@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    let app = Application(.testing)

    override func setUp() async throws {
        try await configure(app)
    }

    override func tearDown() async throws {
        app.shutdown()
    }

    func testRespondsToPing() async throws {
        try app.test(.GET, "ping", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "pong")
        })
    }
}
