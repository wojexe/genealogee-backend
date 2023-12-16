@testable import App
import XCTVapor

final class FamilyOperationsTests: XCTestCase {
    let app = Application(.testing)

    var user = App.User.mock();

    override func setUp() async throws {
        try await configure(app)
    }

    override func tearDown() async throws {
        app.shutdown()
    }

    func testSomething() async throws {
        let person = Person.mock()
        // let family =

        // FamilyOperations.AddChild(familyID: family.id, childID: person.id, on: app.db)
    }
}
