import Fluent
import Vapor

extension Person {
    struct Created: Content {
        var ID: UUID
        var creatorID: UUID
        var treeID: UUID
        var familyID: UUID?
        var parentFamilyID: UUID?
        var givenNames: String
        var familyName: String
        var birthName: String?
        var dateOf: Dates

        init(_ person: Person, _ db: Database) async throws {
            ID = try person.requireID()
            creatorID = person.$creator.id
            treeID = person.$tree.id
            familyID = try await person.$family.get(on: db).first?.id
            parentFamilyID = try await person.$parentFamily.get(on: db).first?.id
            givenNames = person.givenNames
            familyName = person.familyName
            birthName = person.birthName
            dateOf = person.dateOf
        }
    }
}
