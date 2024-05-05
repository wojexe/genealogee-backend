import Vapor
import Fluent

extension Person.DTO {
    struct Send: Content {
        let id: Person.IDValue
        let creatorID: User.IDValue
        let treeID: Tree.IDValue

        let givenNames: String
        let familyName: String
        let birthName: String?
        let dateOf: Dates

        let familyID: Family.IDValue?
        let parentFamilyID: Family.IDValue?

        init(_ person: Person, on db: Database) async throws {
            id = try person.requireID()
            creatorID = person.$creator.id
            treeID = person.$tree.id

            givenNames = person.givenNames
            familyName = person.familyName
            birthName = person.birthName
            dateOf = person.dateOf

            familyID = person.$family.id
            parentFamilyID = person.$parentFamily.id
        }
    }
}
