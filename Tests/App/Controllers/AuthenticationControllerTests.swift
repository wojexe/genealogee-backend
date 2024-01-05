@testable import App
import Fakery
import XCTVapor

final class AuthenticationControllerTests: XCTestCase {
    let faker = Faker()

    var app: Application!

    var userRegister: User.Register!
    var user: User!

    override func setUp() async throws {
        try await super.setUp()

        app = try await Application.testable()

        userRegister = User.Register(email: faker.internet.email(),
                                         name: faker.internet.username(),
                                         password: faker.internet.password(minimumLength: 8, maximumLength: 64))
        let passwordHash = try await app.password.async.hash(userRegister.password)
        user = User(from: userRegister, hash: passwordHash)
        try await user.save(on: app.db)
    }

    override func tearDown() async throws {
        app.shutdown()
    }

    func testRegister() throws {
        let registerRequest = User.Register(email: faker.internet.email(),
                                            name: faker.internet.username(),
                                            password: "super_secure_password123")

        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .created)
        })
    }
}
