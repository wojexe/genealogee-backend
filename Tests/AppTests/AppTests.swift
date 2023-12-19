@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    var app: Application!

    override func setUp() async throws {
        app = try await Application.testable()
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
