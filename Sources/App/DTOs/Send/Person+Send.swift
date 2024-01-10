import Fluent
import Vapor

extension Person.DTO {
    struct Send: Content {
        let id: UUID
        let creatorID: UUID
        let treeID: UUID
        let givenNames: String
        let familyName: String
        let birthName: String?
        let dateOf: Dates

        init(_ person: Person) throws {
            id = try person.requireID()
            creatorID = person.$creator.id
            treeID = person.$tree.id
            givenNames = person.givenNames
            familyName = person.familyName
            birthName = person.birthName
            dateOf = person.dateOf
        }
    }
}
