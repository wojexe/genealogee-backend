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
            self.ID = try person.requireID()
            self.creatorID = person.$creator.id
            self.treeID = person.$tree.id
            self.familyID = try await person.$family.get(on: db).first?.id
            self.parentFamilyID = try await person.$parentFamily.get(on: db).first?.id
            self.givenNames = person.givenNames
            self.familyName = person.familyName
            self.birthName = person.birthName
            self.dateOf = person.dateOf
        }
    }
}
