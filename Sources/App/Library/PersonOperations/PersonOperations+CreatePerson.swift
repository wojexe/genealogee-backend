import Fluent
import Vapor

extension PersonOperations {
    static func CreatePerson(input data: Person.Create, for user: User, on db: Database) async throws {
        let userID = try user.requireID()

        guard let person = try? Person(from: data, creatorID: userID) else {
            throw PersonError(.couldNotInstantiate)
        }

        let tree = try await person.$tree.get(on: db)
        let treeID = try tree.requireID()

        try await db.transaction { db in
            try await person.save(on: db)
            let personID = try person.requireID()

            if try await tree.$families.get(on: db).isEmpty {
                let family = Family(treeID: treeID)
                try await family.save(on: db)

                let familyID = try family.requireID()

                tree.rootFamilyID = familyID
                try await tree.update(on: db)

                let parentLink = ParentLink(familyID: treeID, personID: personID)
                try await parentLink.save(on: db)
            }
        }
    }
}
