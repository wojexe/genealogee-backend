import Fluent
import Vapor

extension Person {
    convenience init(from snapshot: DTO.Snapshot, treeID: UUID, creatorID: UUID) {
        self.init(creatorID: creatorID,
                  treeID: treeID,
                  givenNames: snapshot.givenNames,
                  familyName: snapshot.familyName,
                  birthName: snapshot.birthName,
                  dateOf: Dates(from: snapshot.dateOf))
    }
}

extension Person.DTO {
    struct Snapshot: Codable {
        let sourcePersonID: UUID
        let givenNames: String
        let familyName: String
        let birthName: String?
        let dateOf: Dates.DTO.Snapshot

        init(from person: Person) throws {
            sourcePersonID = try person.requireID()
            givenNames = person.givenNames
            familyName = person.familyName
            birthName = person.birthName
            dateOf = .init(from: person.dateOf)
        }
    }
}

extension Dates {
    convenience init(from snapshot: DTO.Snapshot) {
        let formatter = ISO8601DateFormatter()

        self.init(birth: snapshot.birth != nil ? formatter.date(from: snapshot.birth!) : nil,
                  birthCustom: snapshot.birthCustom,
                  death: snapshot.death != nil ? formatter.date(from: snapshot.death!) : nil,
                  deathCustom: snapshot.deathCustom)
    }
}

extension Dates.DTO {
    struct Snapshot: Content {
        let birth: String?
        let birthCustom: String?
        let death: String?
        let deathCustom: String?

        init(from dateOf: Dates) {
            birth = dateOf.birth?.ISO8601Format()
            birthCustom = dateOf.birthCustom
            death = dateOf.death?.ISO8601Format()
            deathCustom = dateOf.deathCustom
        }
    }
}
