@testable import App
import Fakery
import XCTVapor

final class PersonOperationsTests: XCTestCase {
    let faker = Faker()

    var app: Application?

    var user: User?
    var userID: UUID?

    override func setUp() async throws {
        app = Application(.testing)
        try await configure(app!)

        user = try await App.User.mockSaved(on: app!.db)
        userID = try user!.requireID()
    }

    override func tearDown() async throws {
        app!.shutdown()
    }

    func testCreatePerson() async throws {
        let tree = try await Tree.mockSaved(creatorID: userID!, on: app!.db)
        let treeID = try tree.requireID()

        let personData = Person.Create(
            treeID: treeID,
            givenNames: faker.name.firstName() + faker.name.firstName(),
            familyName: faker.name.lastName(), dateOf: Dates()
        )

    PersonOperations.createPerson(input: personData, for: user!, on: app!.db)

        var person: Person? =
        try await person!.save(on: app!.db)

        let foundPerson = try await Person.find(person!.requireID(), on: app!.db)
        person = try XCTUnwrap(foundPerson)

        XCTAssertEqual(person!.family.count, 1, "Creates a family with the first person as a parent")

        let familyID = try person!.family.first!.requireID()

        XCTAssertEqual(tree.rootFamilyID, familyID, "Sets the tree's rootFamilyID field")

        let parentLink = try await ParentLink
            .find(
                .init(familyID: familyID, personID: person!.requireID()),
                on: app!.db
            )

        XCTAssertNotNil(parentLink)
    }

    func testCreateNextPerson() async throws {
        let tree = try await Tree.mockSaved(creatorID: userID!, on: app!.db)
        let treeID = try tree.requireID()

        var person_one: Person? = try await Person.mockSaved(creatorID: userID!, treeID: treeID, on: app!.db)
        try await person_one!.save(on: app!.db)

        var person_two: Person? = try await Person.mockSaved(creatorID: userID!, treeID: treeID, on: app!.db)
        try await person_one!.save(on: app!.db)

        let foundPerson = try await Person.find(person_two!.requireID(), on: app!.db)
        person_one = try XCTUnwrap(foundPerson)

        XCTAssertEqual(person_one!.family.count, 1, "Creates a family with the first person as a parent")

        let familyID = try person_one!.family.first!.requireID()

        XCTAssertEqual(tree.rootFamilyID, familyID, "Sets the tree's rootFamilyID field")

        let parentLink = try await ParentLink
            .find(
                .init(familyID: familyID, personID: person_one!.requireID()),
                on: app!.db
            )

        XCTAssertNotNil(parentLink)
    }

    func testDeletePerson() async throws {
        let tree = try await Tree.mockSaved(creatorID: userID!, on: app!.db)
        let treeID = try tree.requireID()

        let person = try await Person.mockSaved(creatorID: userID!, treeID: treeID, on: app!.db)
        try await person.save(on: app!.db)
        let personID = try person.requireID()

        try await PersonOperations.deletePerson(personID, on: app!.db)
    }
}
