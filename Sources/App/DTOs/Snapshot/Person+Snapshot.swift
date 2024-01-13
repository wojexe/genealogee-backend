import Fluent
import Vapor

extension Person {
    convenience init(from snapshot: Snapshot, treeID: UUID, creatorID: UUID) {
        self.init(creatorID: creatorID,
                  treeID: treeID,
                  givenNames: snapshot.givenNames,
                  familyName: snapshot.familyName,
                  birthName: snapshot.birthName,
                  dateOf: snapshot.dateOf)
    }

    struct Snapshot: Codable {
        let sourcePersonID: UUID
        let givenNames: String
        let familyName: String
        let birthName: String?
        let dateOf: Dates

        init(from person: Person) throws {
            sourcePersonID = try person.requireID()
            givenNames = person.givenNames
            familyName = person.familyName
            birthName = person.birthName
            dateOf = person.dateOf
        }
    }
}
